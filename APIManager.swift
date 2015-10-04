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
}

extension FirstlyAPI: MoyaTarget {
    public var baseURL: NSURL { return NSURL(string: "http://befirstly.com")! }
    
    public var path: String {
        switch self {
        case .FacebookLogin:
            return "/api/auth/facebook"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .FacebookLogin:
            return .POST
        }
    }
    
    public var parameters: [String: AnyObject] {
        switch self {
        case .FacebookLogin(let token):
            return ["access_token":token]
        }
    }
    
    public var parameterEncoding: Moya.ParameterEncoding {
        return .JSON
    }
    
    public var sampleData: NSData {
        return NSData()
    }
    
}
