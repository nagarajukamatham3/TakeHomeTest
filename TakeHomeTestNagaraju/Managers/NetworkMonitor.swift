//
//  NetworkMonitor.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    var isNetworkConnected = true
    init() {
        monitorNetworkChanges()
    }
    
    
    func monitorNetworkChanges() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print("path.status ---->>3>",path.status)
                self.isNetworkConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
