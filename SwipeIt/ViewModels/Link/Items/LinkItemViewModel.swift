//
//  LinkItemViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 09/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import DateTools
import RxTimer
import TTTAttributedLabel

class LinkItemViewModel: ViewModel {

  // MARK: Private
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let vote: Variable<Vote>
  fileprivate let showSubreddit: Bool

  // MARK: Protected
  let disposeBag: DisposeBag = DisposeBag()
  let link: Link

  // MARK: Calculated Properties
  var title: String {
    return link.title
  }

  var url: URL {
    return link.url
  }

  // MARK: Private Observables
  fileprivate var timeAgo: Observable<NSAttributedString> {
    return Observable
      .combineLatest(Observable.just(link.created), NSTimer.rx_timer) { ($0, $1) }
      .map { (created, _) -> String in
        created.shortTimeAgoSinceNow()
      }.distinctUntilChanged()
      .map { NSAttributedString(string: $0) }
  }

  fileprivate var subredditName: Observable<NSAttributedString?> {
    return Observable.just(showSubreddit ? NSAttributedString(string: link.subreddit,
      attributes: [NSLinkAttributeName: link.subredditURL]) : nil)
  }

  fileprivate var author: Observable<NSAttributedString> {
    return Observable.just(NSAttributedString(string: link.author,
      attributes: [NSLinkAttributeName: link.authorURL]))
  }

  // MARK: Observables
  var context: Observable<NSAttributedString?> {
    return Observable
      .combineLatest(timeAgo, subredditName, author) {
        let result: [NSAttributedString?] = [$0, $1, $2]
        return result.flatMap { $0 }
      }.map { (attributedStrings: [NSAttributedString]) in
        return attributedStrings.joinWithSeparator(" ● ")
    }
  }

  var comments: Observable<NSAttributedString> {
    return .just(NSAttributedString(string: "\(link.totalComments)"))
  }

  var commentsIcon: Observable<UIImage> {
    return .just(UIImage(asset: .CommentsGlyph))
  }

  var score: Observable<NSAttributedString> {
    return Observable
      .combineLatest(Observable.just(link), vote.asObservable()) { ($0, $1) }
      .map { (link, vote) in
        let score = link.hideScore == true ? tr(.LinkScoreHidden) : "\(link.scoreWithVote(vote))"
        switch vote {
        case .Downvote:
          return NSAttributedString(string: score,
            attributes: [NSForegroundColorAttributeName: UIColor(named: .Purple)])
        case .Upvote:
          return NSAttributedString(string: score,
            attributes: [NSForegroundColorAttributeName: UIColor(named: .Orange)])
        default:
          return NSAttributedString(string: score)
        }
    }
  }

  var scoreIcon: Observable<UIImage> {
    return  vote.asObservable()
      .map { vote in
        switch vote {
        case .Downvote:
          return UIImage(asset: .DownvotedGlyph)
        case .Upvote:
          return UIImage(asset: .UpvotedGlyph)
        case .None:
          return UIImage(asset: .NotVotedGlyph)
        }
    }
  }

  // MARK: Initializer
  init(user: User, accessToken: AccessToken, link: Link, showSubreddit: Bool) {
    self.user = user
    self.accessToken = accessToken
    self.link = link
    self.vote = Variable(link.vote)
    self.showSubreddit = showSubreddit
  }

  // MARK: API
  func preloadData() {
    // Nothing to preload in here
  }

  func upvote(_ completion: (Error?) -> Void) {
    vote(.Upvote, completion: completion)
  }

  func downvote(_ completion: (Error?) -> Void) {
    vote(.Downvote, completion: completion)
  }

  func unvote() {
    vote(.None)
  }
}

// MARK: Network
extension LinkItemViewModel {

  fileprivate func vote(_ vote: Vote, completion: ((Error?) -> Void)? = nil) {
    let oldVote = self.vote.value
    self.vote.value = vote
    Network.request(.Vote(token: accessToken.token, identifier: link.name,
      direction: vote.rawValue))
      .subscribe { [weak self] event in
        switch event {
        case .Error(let error):
          self?.vote.value = oldVote
          completion?(error)
        case .Next:
          completion?(nil)
        default: break
        }
      }.addDisposableTo(disposeBag)
  }
}

// MARK: Helpers
extension LinkItemViewModel {

  static func viewModelFromLink(_ link: Link, user: User, accessToken: AccessToken,
                                subredditOnly: Bool) -> LinkItemViewModel {
    switch link.type {
    case .video:
      return LinkItemVideoViewModel(user: user, accessToken: accessToken, link: link,
                                    showSubreddit: !subredditOnly)
    case .image, .gif, .album:
      return LinkItemImageViewModel(user: user, accessToken: accessToken, link: link,
                                    showSubreddit: !subredditOnly)
    case .selfPost:
      return LinkItemSelfPostViewModel(user: user, accessToken: accessToken, link: link,
                                       showSubreddit: !subredditOnly)
    case .linkPost:
      return LinkItemLinkViewModel(user: user, accessToken: accessToken, link: link,
                                   showSubreddit: !subredditOnly)
    }
  }
}
