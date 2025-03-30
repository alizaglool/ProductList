//
//  ProductCacheService.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import Foundation
import Networking

final class ProductCacheService: ProductCacheServiceProtocol {
    
    private let fileName = "cached_products.json"
    
    private var fileURL: URL {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName)
    }
    
    func save(products: [Product]) {
        do {
            let data = try JSONEncoder().encode(products)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("⚠️ Failed to save cached products: \(error)")
        }
    }
    
    func load() -> [Product]? {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            print("⚠️ Failed to load cached products: \(error)")
            return nil
        }
    }
    
    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
