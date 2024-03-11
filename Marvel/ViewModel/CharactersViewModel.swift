import Foundation

class CharacterViewModel {
    
    private let marvelService = MarvelAPIService()
    
    func fetchMarvelCharacters(completion: @escaping (Result<CharacterDataWrapper, Error>) -> Void) {
        marvelService.fetchCharacters { data, error, statusCode in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.unknown))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let characterResponse = try decoder.decode(CharacterResponse.self, from: data)
                
                completion(.success(characterResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
