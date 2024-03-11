import UIKit

class CharacterViewController: UIViewController {
    
    let characterViewModel = CharacterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterViewModel.fetchMarvelCharacters { result in
            switch result {
            case .success(let characterData):
                print("Character Data: \(characterData)")
            case .failure(let error):
                print("Error fetching Marvel characters: \(error)")
            }
        }
    }
}
