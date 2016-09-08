//
//  SubredditLinkListViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 09/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Properties and initializer
class LinkSwipeViewModel {

  // MARK: Private Properties
  fileprivate let _title: String
  fileprivate let path: String
  fileprivate let subredditOnly: Bool
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let linkListings: Variable<[LinkListing]> = Variable([])
  fileprivate let _viewModels: Variable<[LinkItemViewModel]> = Variable([])
  fileprivate let _listingType: Variable<ListingType> = Variable(.Hot)
  fileprivate var disposeBag = DisposeBag()
  fileprivate let _loadingState = Variable<LoadingState>(.Normal)

  // MARK: Initializer
  init(user: User, accessToken: AccessToken, title: String, path: String, subredditOnly: Bool) {
    self.user = user
    self.accessToken = accessToken
    self._title = title
    self.path = path
    self.subredditOnly = subredditOnly
  }

  convenience init(user: User, accessToken: AccessToken, subreddit: Subreddit) {
    self.init(user: user, accessToken: accessToken, title: subreddit.displayName,
              path: subreddit.path, subredditOnly: true)
  }

  convenience init(user: User, accessToken: AccessToken, multireddit: Multireddit) {
    self.init(user: user, accessToken: accessToken, title: multireddit.name,
              path: multireddit.path, subredditOnly: false)
  }
}

// MARK: Private Observables
extension LinkSwipeViewModel {

  fileprivate var userObservable: Observable<User> {
    return .just(user)
  }

  fileprivate var accessTokenObservable: Observable<AccessToken> {
    return .just(accessToken)
  }

  fileprivate var afterObservable: Observable<String?> {
    return linkListings.asObservable()
      .map { $0.last?.after }
  }

  fileprivate var listingTypeObservable: Observable<ListingType> {
    return _listingType.asObservable()
  }

  fileprivate var pathObservable: Observable<String> {
    return .just(path)
  }

  fileprivate var subredditOnlyObservable: Observable<Bool> {
    return .just(subredditOnly)
  }

  fileprivate var request: Observable<LinkListing> {
    return Observable
      .combineLatest(listingTypeObservable, afterObservable, accessTokenObservable,
        pathObservable) { ($0, $1, $2, $3) }
      .take(1)
      .doOnNext { [weak self] _ in
        self?._loadingState.value = .Loading
      }.flatMap {
        (listingType: ListingType, after: String?, accessToken: AccessToken, path: String) in
        Network.request(RedditAPI.LinkListing(token: accessToken.token,
          path: path, listingPath: listingType.path, listingTypeRange: listingType.range?.rawValue,
          after: after))
      }.observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
      .mapObject(LinkListing)
      .observeOn(MainScheduler.instance)
  }
}

// MARK: Public API
extension LinkSwipeViewModel {

  var viewModels: Observable<[LinkItemViewModel]> {
    return _viewModels.asObservable()
  }

  var loadingState: Observable<LoadingState> {
    return _loadingState.asObservable()
  }

  var listingTypeName: Observable<String> {
    return _listingType.asObservable()
      .map { $0.name }
  }

  func viewModelForIndex(_ index: Int) -> LinkItemViewModel? {
    return _viewModels.value.get(index)
  }

  func requestLinks() {
    guard _loadingState.value != .Loading else { return }

    Observable
      .combineLatest(request, userObservable, accessTokenObservable, subredditOnlyObservable) {
        ($0, $1, $2, $3)
      }.take(1)
      .subscribe { [weak self] event in
        guard let `self` = self else { return }

        switch event {
        case let .Next(linkListing, user, accessToken, subredditOnly):
          self.linkListings.value.append(linkListing)
          let viewModels = LinkSwipeViewModel.viewModelsFromLinkListing(linkListing,
            user: user, accessToken: accessToken, subredditOnly: subredditOnly)
          viewModels.forEach { $0.preloadData() }
          self._loadingState.value = self._viewModels.value.count > 0 ? .Normal : .Empty
          self._viewModels.value += viewModels
          if viewModels.count <= 4 {
            self.requestLinks()
          }
        case .Error:
          self._loadingState.value = .Error
        default: break
        }

      }.addDisposableTo(disposeBag)
  }

  func setListingType(_ listingType: ListingType) {
    guard listingType != _listingType.value else { return }
    _listingType.value = listingType
    refresh()
  }

  func refresh() {
    linkListings.value = []
    _viewModels.value = []
    disposeBag = DisposeBag()
    _loadingState.value = .Normal
    requestLinks()
  }
}

// MARK: Helpers
extension LinkSwipeViewModel {

  fileprivate static func viewModelsFromLinkListing(_ linkListing: LinkListing, user: User,
                                                accessToken: AccessToken, subredditOnly: Bool)
    -> [LinkItemViewModel] {
      return linkListing.links
        .filter { !$0.stickied }
        .filter { !Globals.hideVotedPosts || $0.vote == .none }
        .filter { $0.type == .image || $0.type == .gif }
        .map { LinkItemViewModel.viewModelFromLink($0, user: user, accessToken: accessToken,
          subredditOnly: subredditOnly)
      }
  }
}

// MARK: TitledViewModel
extension LinkSwipeViewModel: TitledViewModel {

  var title: Observable<String> {
    return .just(_title)
  }
}
