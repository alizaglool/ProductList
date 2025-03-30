//
//  File.swift
//  
//
//  Created by Zaghloul on 12/06/2023.
//

import Foundation

public enum EndPoints: String {
    
    case baseURL = "https://fakestoreapi.com/"
    
    public var value: String {
        return self.rawValue
    }
}
