//
//  LoginViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Device
import RxSwift
import Moya_ObjectMapper
import ObjectMapper
import Result

// MARK: Properties and Initializer
class LoginViewModel {

  // MARK: Static
  fileprivate static let clientId = "S8m1IOZ4TW9vLQ"
  fileprivate static let redirectURL = "https://github.com/ivanbruel/SwipeIt"
  fileprivate static let responseType = "code"
  fileprivate static let duration = Duration.Permanent
  fileprivate static let scopes: [Scope] = [.Subscribe, .Vote, .MySubreddits, .Submit, .Save, .Read,
                                        .Report, .Identity, .Account, .Edit, .History]
  /// Show Compact page only on iPhone
  fileprivate static var authorizePath: String = {
    return Device.type() == .iPad ? "authorize" : "authorize.compact"
  }()
  fileprivate static var scopeString: String {
    return scopes.map { $0.rawValue }.joined(separator: ",")
  }

  // MARK: Public Properties
  var oauthURLString: String {
    return "https://www.reddit.com/api/v1/\(LoginViewModel.authorizePath)?" +
      "client_id=\(LoginViewModel.clientId)&response_type=\(LoginViewModel.responseType)" +
      "&state=\(state)&redirect_uri=\(LoginViewModel.redirectURL)" +
      "&duration=\(LoginViewModel.duration.rawValue)&scope=\(LoginViewModel.scopeString)"
  }

  var loginResult: Observable<Result<AccessToken, LoginError>> {
    return _loginResult.asObservable()
  }

  // MARK: Private Properties
  fileprivate let state = UUID().uuidString
  fileprivate let _loginResult = ReplaySubject<Result<AccessToken, LoginError>>.create(bufferSize: 1)
  fileprivate let disposeBag = DisposeBag()

  // MARK: Initializer
  init() {
    reuseToken()
  }

  deinit {
    // Signal onCompleted when view model is released
    self._loginResult.onCompleted()
  }

}

// MARK: Token Reuse
extension LoginViewModel {

  // Automatic login in case we already have a valid access token
  // Or refresh the token if it has expired
  fileprivate func reuseToken() {
    guard let accessToken = Globals.accessToken else { return }

    // Refresh token if it has a refreshToken and the access token is invalid
    if let oldRefreshToken = accessToken.refreshToken, !accessToken.tokenIsValid {
        refreshToken(oldRefreshToken)
        return
    }

    // Use token if token is valid
    if accessToken.tokenIsValid {
      _loginResult.onNext(Result(accessToken))
    }
  }

}

// MARK: TitledViewModel
extension LoginViewModel: TitledViewModel {

  var title: Observable<String> {
    return .just(tr(.LoginTitle))
  }

}

// MARK: Validation
extension LoginViewModel {

  func isRedirectURL(_ URLString: String) -> Bool {
    return URLString.hasPrefix(LoginViewModel.redirectURL)
  }

  func loginWithRedirectURL(_ URLString: String) {
    // Checks if the redirect URL is the prefix of URLString, returns Unknown error in case it's not
    guard URLString.hasPrefix(LoginViewModel.redirectURL) else {
      _loginResult.onNext(Result(error: .Unknown))
      return
    }

    let queryParameters = QueryReader.queryParametersFromString(URLString)

    // Look for state and code query parameters, if they don't exist, the user Cancelled.
    guard let state = queryParameters["state"],
      let code = queryParameters["code"],
      state == self.state else {
        _loginResult.onNext(Result(error: .UserCancelled))
        return
    }

    // Ask for the access token with the OAuth code
    getAccessToken(code)
  }

  fileprivate func successfulLogin(_ accessToken: AccessToken) {
    Globals.accessToken = accessToken
    _loginResult.onNext(Result(accessToken))
  }
}

// MARK: Networking
extension LoginViewModel {

  // Retrieve the access token from the OAuth API, save it in the keychain for automatic login.
  fileprivate func getAccessToken(_ code: String) {
    Network.request(.AccessToken(code: code, redirectURL: LoginViewModel.redirectURL,
      clientId: LoginViewModel.clientId))
      .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
      .mapObject(AccessToken)
      .observeOn(MainScheduler.instance)
      .bindNext { [weak self] accessToken in
        self?.successfulLogin(accessToken)
      }.addDisposableTo(disposeBag)
  }

  // The Refresh Token request does not send a new refresh_token, therefor we need to reuse the
  // refresh token from the old AccessToken.
  fileprivate func refreshToken(_ refreshToken: String) {

    let networkRequest = Network.request(.RefreshToken(refreshToken: refreshToken,
      clientId: LoginViewModel.clientId))
      .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
      .mapObject(AccessToken)
      .observeOn(MainScheduler.instance)

    Observable
      .combineLatest(networkRequest, Observable.just(refreshToken)) { ($0, $1) }
      .map { (accessToken: AccessToken, refreshToken: String) in
        AccessToken(accessToken: accessToken, refreshToken: refreshToken)
      }
      .bindNext { [weak self] accessToken in
        self?.successfulLogin(accessToken)
      }.addDisposableTo(disposeBag)
  }
}
