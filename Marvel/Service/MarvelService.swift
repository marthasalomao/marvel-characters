import Foundation

protocol MarvelAPIServiceProtocol {
    func fetchCharacters(offset: Int, completion: @escaping (Data?, Error?, Int?) -> Void)
}

class MarvelAPIService: MarvelAPIServiceProtocol {
    
    func fetchCharacters(offset: Int, completion: @escaping (Data?, Error?, Int?) -> Void) {
        let publicKey = Secrets.marvelPublicKey
        let privateKey = Secrets.marvelPrivateKey
        let baseURL = "https://gateway.marvel.com/v1/public/characters"
        
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let hash = (timeStamp + privateKey + publicKey).md5Hash
        let urlString = "\(baseURL)?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, CustomError.network, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error ?? CustomError.unknown, nil)
                return
            }
            
            completion(data, nil, (response as? HTTPURLResponse)?.statusCode)
        }.resume()
    }
}
