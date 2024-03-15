import UIKit
import SystemConfiguration

class InternetConnectCheckClass {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    class func handleNoInternetConnection(from viewController: UIViewController, retryAction: (() -> Void)?) {
        guard !isConnectedToNetwork() else { return }
        
        let alert = UIAlertController(title: "No Internet Connection",
                                      message: "Please check your connection and try again.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction?()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
