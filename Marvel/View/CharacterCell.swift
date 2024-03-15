import UIKit

class CharacterCell: UICollectionViewCell {
    static let reuseIdentifier = "CharacterCell"
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(characterImageView)
        addSubview(labelBackgroundView)
        labelBackgroundView.addSubview(nameLabel)
        addSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: labelBackgroundView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: labelBackgroundView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: labelBackgroundView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        
        let imageURLString = character.thumbnail.path + "." + character.thumbnail.fileExtension
        guard let imageURL = URL(string: imageURLString) else {
            print("Invalid URL for character image")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                }
            } else {
                print("Failed to load character image")
            }
        }
    }
}
