import Foundation
import CryptoKit

extension String {
    var md5Hash: String {
        guard let data = self.data(using: .utf8) else { return "" }
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
