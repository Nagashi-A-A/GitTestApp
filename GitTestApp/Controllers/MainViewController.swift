/// - Main controller for Tab Bar purpose.
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarVC = UITabBarController()
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        StorageService.shared.uploadFromStorage()
        tabBarVC.setViewControllers([searchVC, favoritesVC], animated: true)
        searchVC.title = "Repository Search"
        favoritesVC.title = "Favorites"
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "magnifyingglass.circle.fill")
        items[1].image = UIImage(systemName: "star.fill")
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }
}
