import Foundation

class MarvelAPIService {
    
    private let baseURL = "https://gateway.marvel.com/v1/public/"
    private let publicKey = Secrets.marvelPublicKey
    private let privateKey = Secrets.marvelPrivateKey
    
    func getRequest(url: String, completion: @escaping (Data?, Error?, Int?) -> Void) {
        guard InternetConnectCheckClass.isConnectedToNetwork() else {
            completion(nil, CustomError.network, nil)
            return
        }
        
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, error, nil)
                    return
                }
                if let error = error {
                    completion(nil, error, httpResponse.statusCode)
                    return
                }
                completion(data, nil, httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func fetchCharacters(completion: @escaping (Data?, Error?, Int?) -> Void) {
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let hash = (timeStamp + privateKey + publicKey).md5Hash
        let urlString = "\(baseURL)characters?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
        
        getRequest(url: urlString, completion: completion)
    }
}
