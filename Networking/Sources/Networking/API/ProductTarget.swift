//
//  File.swift
//
//
//  Created by Zaghloul on 15/06/2023.
//

import Foundation
import Alamofire

public enum ProductTarget {
    case getProducts(limit: Int, offset: Int)
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
        case .getProducts(let limit, let offset):
            let params: [String: Any] = [
                "limit": limit,
                "offset": offset
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
}

