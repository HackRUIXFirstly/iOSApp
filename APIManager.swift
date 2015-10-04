//
//  APIManager.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import Foundation
import Moya

public enum FirstlyAPI {
    case FacebookLogin(String)
    case PostExperience(String, String)
    case Feed(String)
}

extension FirstlyAPI: MoyaTarget {
    public var baseURL: NSURL { return NSURL(string: "http://shiggy.xyz")! }
    
    public var path: String {
        switch self {
        case .FacebookLogin:
            return "/api/auth/facebook"
        case .PostExperience(_, _):
            return "/api/experience"
        case .Feed(_):
            return "/api/user/feed"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .FacebookLogin:
            return .POST
        case .PostExperience(_, _):
            return .POST
        case .Feed(_):
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject] {
        switch self {
        case .FacebookLogin(let token):
            return ["access_token":token]
        case .PostExperience(let token, let text):
            return ["access_token":token, "text":text]
        case .Feed(let token):
            return["access_token":token]
        }
    }
    
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .Feed(_):
            Moya.ParameterEncoding.URL
        default:
            return Moya.ParameterEncoding.JSON
        }
        return Moya.ParameterEncoding.JSON
    }
    
    public var sampleData: NSData {
        return NSData()
    }
    
}
