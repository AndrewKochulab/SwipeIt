//
//  Network.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class Network {

  fileprivate static var provider = RxMoyaProvider<RedditAPI>(endpointClosure: {
    target -> Endpoint<RedditAPI> in
    return Endpoint<RedditAPI>(URL: target.url,
      sampleResponseClosure: { .NetworkResponse(200, target.sampleData) },
      method: target.method,
      parameters: target.parameters,
      parameterEncoding: target.parameterEncoding,
      httpHeaderFields: target.headers)
    }, plugins: [
      //NetworkLoggerPlugin(cURL: true),
      credentialsPlugin
    ])

  fileprivate static var credentialsPlugin = CredentialsPlugin { target -> URLCredential? in
    guard let target = target as? RedditAPI else { return nil }
    return target.credentials
  }
}

// MARK: Public Methods
extension Network {

  static func request(_ target: RedditAPI) -> Observable<Response> {
    return provider.request(target)
  }
}
