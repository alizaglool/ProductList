//
//  NetworkMonitorService.swift
//  ProductListTRU
//
//  Created by Ali M. Zaghloul on 30/03/2025.
//


import Network
import RxRelay

final class NetworkMonitorService: NetworkMonitorServiceProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    
    var connectionStatus = BehaviorRelay<Bool>(value: true)
    
    var isConnected: Bool {
        return connectionStatus.value
    }
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.connectionStatus.accept(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}

enum NetworkError: Error {
    case noConnection
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection. Please try again later."
        }
    }
}
