import Foundation

protocol CharacterViewModelDelegate: AnyObject {
    func didFetchCharactersSuccessfully(_ characters: [Character])
    func didFailToFetchCharacters(with error: Error)
}

class CharacterViewModel {
    
    private let marvelService = MarvelAPIService()
    weak var delegate: CharacterViewModelDelegate?
    
    var characters: [Character] = []
    
    func fetchCharactersIfNeeded() {
        guard characters.isEmpty else {
            delegate?.didFetchCharactersSuccessfully(characters)
            return
        }
        
        // If the list of characters is empty, make an API call to retrieve it
        fetchCharacters()
    }
    
    func fetchCharacters() {
        marvelService.fetchCharacters { [weak self] data, error, statusCode in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.didFailToFetchCharacters(with: error)
                return
            }
            
            guard let data = data else {
                self.delegate?.didFailToFetchCharacters(with: CustomError.unknown)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let characterResponse = try decoder.decode(CharacterResponse.self, from: data)
                
                let characters = characterResponse.data.results
                self.characters = characters // Cache the characters
                self.delegate?.didFetchCharactersSuccessfully(characters)
            } catch {
                self.delegate?.didFailToFetchCharacters(with: error)
            }
        }
    }
}
