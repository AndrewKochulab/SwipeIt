//
//  RedditAPI.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya

enum RedditAPI {

  case accessToken(code: String, redirectURL: String, clientId: String)
  case refreshToken(refreshToken: String, clientId: String)
  case subredditListing(token: String, after: String?)
  case defaultSubredditListing(after: String?)
  case multiredditListing(token: String)
  case linkDetails(token: String, permalink: String)
  case linkListing(token: String, path: String, listingPath: String, listingTypeRange: String?,
    after: String?)
  case userDetails(token: String, username: String)
  case userMeDetails(token: String)
  case vote(token: String, identifier: String, direction: Int)

}

extension RedditAPI: TargetType {

  var baseURL: URL {
    guard let _ = token else {
      return URL(string: "https://www.reddit.com")!
    }
    return URL(string: "https://oauth.reddit.com")!
  }

  var path: String {
    switch self {
    case .accessToken, .refreshToken:
      return "/api/v1/access_token"
    case .multiredditListing:
      return "/api/multi/mine"
    case .subredditListing:
      return "/subreddits/mine"
    case .defaultSubredditListing:
      return "/subreddits/default"
    case .linkListing(_, let path, let listingPath, _, _):
      return "\(path)\(listingPath)"
    case .linkDetails(_, let permalink):
      return permalink
    case .userMeDetails(_):
      return "/api/v1/me"
    case .userDetails(_, let username):
      return "/user/\(username)/about"
    case .vote:
      return "/api/vote"
    }
  }

  var method: Moya.Method {
    switch self {
    case .accessToken, .refreshToken, .vote:
      return .POST
    default:
      return .GET
    }
  }

  var parameters: [String: AnyObject]? {
    switch self {
    case .accessToken(let code, let redirectURL, _):
      return [
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectURL]
    case .refreshToken(let refreshToken, _):
      return [
        "grant_type": "refresh_token",
        "refresh_token": refreshToken
      ]
    case .subredditListing(_, let after):
      guard let after = after else {
        return nil
      }
      return ["after": after]
    case .defaultSubredditListing(let after):
      guard let after = after else {
        return nil
      }
      return ["after": after]
    case .linkListing(_, _, _, let listingTypeRange, let after):
      guard let after = after else {
        return nil
      }
      return JSONHelper.flatJSON(["after": after, "t": listingTypeRange])
    case .vote(_, let identifier, let direction):
      return ["id": identifier, "dir": direction]
    default:
      return nil
    }
  }

  var sampleData: Data {
    switch self {
    case .accessToken, .refreshToken:
      return JSONReader.readJSONData("AccessToken")
    case .subredditListing:
      return JSONReader.readJSONData("SubredditListing")
    case .defaultSubredditListing:
      return JSONReader.readJSONData("SubredditListing")
    case .linkListing:
      return JSONReader.readJSONData("LinkListing")
    case .multiredditListing:
      return JSONReader.readJSONData("MultiredditListing")
    case .linkDetails:
      return JSONReader.readJSONData("LinkDetails")
    case .userDetails, .userMeDetails:
      return JSONReader.readJSONData("UserDetails")
    case .vote:
      return JSONReader.readJSONData("Upvoted")
    }
  }

  var headers: [String: String]? {
    guard let token = token else {
      return nil
    }
    return ["Authorization": "bearer \(token)"]
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .accessToken, .refreshToken:
      return .URL
    case .vote:
      return .URLEncodedInURL
    default:
      return method == .GET ? .URL : .JSON
    }
  }

  var token: String? {
    switch self {
    case .subredditListing(let token, _):
      return token
    case .linkListing(let token, _, _, _, _):
      return token
    case .multiredditListing(let token):
      return token
    case .linkDetails(let token, _):
      return token
    case .userDetails(let token, _):
      return token
    case .userMeDetails(let token):
      return token
    case .vote(let token, _, _):
      return token
    default:
      return nil
    }
  }

  var url: String {
    return "\(baseURL)\(path).json"
  }

  var multipartBody: [MultipartFormData]? {
    return nil
  }

  var credentials: URLCredential? {
    switch self {
    case .accessToken(_, _, let clientId):
      return URLCredential(user: clientId, password: "", persistence: .none)
    case .refreshToken(_, let clientId):
      return URLCredential(user: clientId, password: "", persistence: .none)
    default:
      return nil
    }
  }

}
