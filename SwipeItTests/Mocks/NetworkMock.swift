//
//  NetworkMock.swift
//  Reddit
//
//  Created by Ivan Bruel on 22/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class NetworkMock {

  fileprivate static var provider = RxMoyaProvider<RedditAPI>(endpointClosure: {
    target -> Endpoint<RedditAPI> in
    return Endpoint<RedditAPI>(URL: target.url,
      sampleResponseClosure: { .NetworkResponse(200, target.sampleData) },
      method: target.method,
      parameters: target.parameters,
      parameterEncoding: target.parameterEncoding,
      httpHeaderFields: target.headers)
    }, stubClosure: MoyaProvider.ImmediatelyStub)

  fileprivate static var credentialsPlugin = CredentialsPlugin { target -> URLCredential? in
    guard let target = target as? RedditAPI else { return nil }
    return target.credentials
  }
}

// MARK: Public Methods
extension NetworkMock {

  static func request(_ target: RedditAPI) -> Observable<Response> {
    return provider.request(target)
  }
}
