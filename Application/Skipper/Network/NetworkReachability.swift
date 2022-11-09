//
//  NetworkReachability.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Combine
import Network
import SystemConfiguration

enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

protocol NetworkReachability {
    func isConnectedToNetwork() -> Bool

    func setupMonitoring()
    func startMonitoring()

    var connectionTypePublisher: Published<ConnectionType>.Publisher { get }
    var connectionType: ConnectionType { get }
}

class RemoteNetworkReachability: NetworkReachability {
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    private var previousPath: NWPath?
    var isReachable: Bool { status == .satisfied }

    @Published private(set) var connectionType: ConnectionType = .wifi

    var connectionTypePublisher: Published<ConnectionType>.Publisher {
        $connectionType
    }

    init() {
        setupMonitoring()
    }

    /// Detects whether the device connected to LTE or Wi-Fi module or not
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }

    /// Detects internet connection changes
    func setupMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == NWPath.Status.satisfied {
                Log.console("Network status: Connected")
            } else if path.status == NWPath.Status.unsatisfied {
                Log.console("Network status: Unsatisfied")
            } else if path.status == NWPath.Status.requiresConnection {
                Log.console("Network status: Requires connection")
            }

            if let previous = self.previousPath {
                self.status = previous.status
            } else {
                self.status = path.status
            }
            self.previousPath = path
            self.connectionType = self.checkConnectionTypeForPath(self.previousPath!)
        }

        startMonitoring()
    }

    func startMonitoring() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func stopMonitor() {
        monitor.cancel()
    }

    private func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .unknown
    }
}
