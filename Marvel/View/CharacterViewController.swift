import UIKit

class CharacterViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Characters"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
        return tableView
    }()
    
    private let viewModel = CharacterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewModel.delegate = self
        viewModel.fetchCharactersIfNeeded()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(charactersTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            charactersTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            charactersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        let character = viewModel.filteredCharacters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.filteredCharacters[indexPath.row]
        showCharacterDetails(for: character)
    }
    
    private func showCharacterDetails(for character: Character) {
        let characterDetailVC = CharacterDetailViewController()
        characterDetailVC.character = character
        characterDetailVC.title = character.name
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }

}

extension CharacterViewController: CharacterViewModelDelegate {
    func didUpdateFilteredCharacters(_ characters: [Character]) {
        viewModel.filteredCharacters = characters
        charactersTableView.reloadData()
    }
    
    func didFetchCharactersSuccessfully(_ characters: [Character]) {
        viewModel.allCharacters = characters
        viewModel.searchCharacters(with: searchBar.text ?? "")
    }
    
    func didFailToFetchCharacters(with error: Error) {
        print("Failed to fetch characters: \(error)")
    }
}

extension CharacterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCharacters(with: searchText)
    }
}
