import Foundation
import CryptoKit

extension String {
    var md5Hash: String {
        guard let data = self.data(using: .utf8) else { return "" }
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {
    func levenshteinDistance(to target: String) -> Int {
        let sourceArray = Array(self)
        let targetArray = Array(target)

        var distances = Array(repeating: Array(repeating: 0, count: targetArray.count + 1), count: sourceArray.count + 1)

        for i in 1...sourceArray.count {
            distances[i][0] = i
        }

        for j in 1...targetArray.count {
            distances[0][j] = j
        }

        for i in 1...sourceArray.count {
            for j in 1...targetArray.count {
                let cost = sourceArray[i - 1] == targetArray[j - 1] ? 0 : 1
                distances[i][j] = Swift.min(
                    distances[i - 1][j] + 1,
                    distances[i][j - 1] + 1,
                    distances[i - 1][j - 1] + cost
                )
            }
        }

        return distances[sourceArray.count][targetArray.count]
    }
}
