import UIKit

class CharacterViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Characters"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var charactersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let viewModel = CharacterViewModel()
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewModel.delegate = self
        viewModel.fetchCharactersIfNeeded()
        title = "Characters"
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(charactersCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            charactersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            charactersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 15) / 2 // Assuming 30 is the total spacing between cells
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        let character = viewModel.filteredCharacters[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.filteredCharacters[indexPath.item]
        showCharacterDetails(for: character)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isLoading {
                isLoading = true
                viewModel.fetchNextPage()
            }
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel.filteredCharacters = characters
            self.charactersCollectionView.reloadData()
        }
    }
    
    func didFetchCharactersSuccessfully(_ characters: [Character]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel.allCharacters += characters
            self.viewModel.searchCharacters(with: self.searchBar.text ?? "")
            self.isLoading = false
        }
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
