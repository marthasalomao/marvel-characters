import Foundation
@testable import Marvel

class MockMarvelAPIService: MarvelAPIServiceProtocol {
    static var error: Error?
    static var success = true
    static var characters: [Character] = []
    
    func fetchCharacters(completion: @escaping (Data?, Error?, Int?) -> Void) {
        if let error = MockMarvelAPIService.error {
            completion(nil, error, nil)
        } else {
            let data: Data
            do {
                data = try JSONEncoder().encode(MockMarvelAPIService.characters)
            } catch {
                completion(nil, error, nil)
                return
            }
            completion(data, nil, MockMarvelAPIService.success ? 200 : 500)
        }
    }
}


