//
//  NetworkMonitorServiceProtocol.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//

import RxRelay

protocol NetworkMonitorServiceProtocol {
    var isConnected: Bool { get }
    var connectionStatus: BehaviorRelay<Bool> { get }
}
