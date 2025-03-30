//
//  File.swift
//
//
//  Created by Zaghloul on 15/06/2023.
//

import Foundation
import Alamofire

public enum ProductTarget {
    case getProducts
}

extension ProductTarget: TargetType {
    public var baseURL: String {
        return EndPoints.baseURL.value
    }
    
    public var path: String {
        switch self {
        case .getProducts:
            return "products"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getProducts:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
}

