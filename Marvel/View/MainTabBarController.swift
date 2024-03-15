import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        let characterVC = CharacterViewController()
        let favoriteVC = FavoriteCharactersViewController()
        
        let characterNav = UINavigationController(rootViewController: characterVC)
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        
        if let characterImage = UIImage(named: "Characters")?.withRenderingMode(.alwaysOriginal).resize(targetSize: CGSize(width: 24, height: 24)) {
            characterNav.tabBarItem = UITabBarItem(title: "Characters", image: characterImage, tag: 0)
            characterNav.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            characterNav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        }
            
        favoriteNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        favoriteNav.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        favoriteNav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        
        let viewControllers = [characterNav, favoriteNav]
        self.setViewControllers(viewControllers, animated: false)
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
