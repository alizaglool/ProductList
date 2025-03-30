//
//  ProductCacheServiceProtocol.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import Networking

protocol ProductCacheServiceProtocol {
    func save(products: [Product])
    func load() -> [Product]?
    func clear()
}
