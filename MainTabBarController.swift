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
        
        characterNav.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3.fill"), tag: 0)
        favoriteNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        
        let viewControllers = [characterNav, favoriteNav]
        self.setViewControllers(viewControllers, animated: false)
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }
}
