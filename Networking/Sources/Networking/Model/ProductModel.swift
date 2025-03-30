//
//  File.swift
//  
//
//  Created by Zaghloul on 18/06/2023.
//

import Foundation

// MARK: - Product Model -

public struct Product: Codable {
    public let id: Int
    public let title: String
    public let price: Double
    public let description: String
    public let category: String
    public let image: String
}

