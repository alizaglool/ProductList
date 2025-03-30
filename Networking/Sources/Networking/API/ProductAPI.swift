//
//  File.swift
//  
//
//  Created by Zaghloul on 15/06/2023.
//

import Foundation

public protocol ProductAPIProtocol {
    func getProducts(limit: Int, offset: Int, completion: @escaping (Result<[Product]?, Error>) -> Void)
}

public class ProductAPI: BaseAPI<ProductTarget>, ProductAPIProtocol {
    
    public override init() {}
}

// MARK: - Get Cuurncy -

extension ProductAPI {
    public func getProducts(limit: Int, offset: Int, completion: @escaping (Result<[Product]?, Error>) -> Void) {
        connectWithServer(target: .getProducts(limit: limit, offset: offset)) { result in
            completion(result)
        }
    }
}
