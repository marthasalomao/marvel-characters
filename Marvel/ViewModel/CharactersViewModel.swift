import Foundation

protocol CharacterViewModelDelegate: AnyObject {
    func didFetchCharactersSuccessfully(_ characters: [Character])
    func didFailToFetchCharacters(with error: Error)
    func didUpdateFilteredCharacters(_ characters: [Character])
}

class CharacterViewModel {
    
    private let marvelService = MarvelAPIService()
    weak var delegate: CharacterViewModelDelegate?
    
    var allCharacters: [Character] = []
    var filteredCharacters: [Character] = []
    
    func fetchCharactersIfNeeded() {
        guard allCharacters.isEmpty else {
            delegate?.didFetchCharactersSuccessfully(allCharacters)
            return
        }
        
        fetchCharacters()
    }
    
    private func fetchCharacters() {
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
                self.allCharacters = characters
                self.delegate?.didFetchCharactersSuccessfully(characters)
            } catch {
                self.delegate?.didFailToFetchCharacters(with: error)
            }
        }
    }
    
    func searchCharacters(with searchText: String) {
        if searchText.isEmpty {
            delegate?.didUpdateFilteredCharacters(allCharacters)
        } else {
            filteredCharacters = allCharacters.filter { character in
                return character.name.lowercased().contains(searchText.lowercased())
            }.sorted { character1, character2 in
                let distance1 = character1.name.lowercased().levenshteinDistance(to: searchText.lowercased())
                let distance2 = character2.name.lowercased().levenshteinDistance(to: searchText.lowercased())
                return distance1 < distance2
            }
            delegate?.didUpdateFilteredCharacters(filteredCharacters)
        }
    }
}
