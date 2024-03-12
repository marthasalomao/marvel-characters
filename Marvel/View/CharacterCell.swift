import UIKit

class CharacterCell: UITableViewCell {
    static let reuseIdentifier = "CharacterCell"
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(characterImageView)
        addSubview(nameLabel)
        addSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -16),
            favoriteButton.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        
        let imageURLString = character.thumbnail.path + "." + character.thumbnail.fileExtension
        guard let imageURL = URL(string: imageURLString) else {
            print("URL inválida para a imagem do personagem")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                }
            } else {
                print("Falha ao carregar a imagem do personagem")
            }
        }
    }
}
