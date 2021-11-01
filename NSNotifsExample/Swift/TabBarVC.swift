import UIKit


class TabBarVC : UITabBarController {

	override func viewDidLoad() {

		super.viewDidLoad()

		// instantiate our view controllers, would be something like this in objC --> [FirstVC new];

		let firstVC = FirstVC()
		let secondVC = SecondVC()

		// create our navigation bars and give them titles

		firstVC.title = "Home"
		secondVC.title = "Not Home"

		let firstNav = UINavigationController(rootViewController: firstVC)
		let secondNav = UINavigationController(rootViewController: secondVC)

		// create our UITabBarItems

		firstNav.tabBarItem = UITabBarItem(title: "Home", image:UIImage(systemName: "bolt.horizontal.fill"), tag:0)
		secondNav.tabBarItem = UITabBarItem(title: "Not Home", image:UIImage(systemName: "bonjour"), tag:1)

		// let the tab bar controller know of the view controllers we want to display

		setViewControllers([firstNav, secondNav], animated: false)

		// customization

		firstNav.navigationBar.barTintColor = .black
		firstNav.navigationBar.isTranslucent = false

		secondNav.navigationBar.barTintColor = .black
		secondNav.navigationBar.isTranslucent = false

		firstNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		firstNav.navigationBar.shadowImage = UIImage()

		secondNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		secondNav.navigationBar.shadowImage = UIImage()

		tabBar.barTintColor = .black
		tabBar.isTranslucent = false

		tabBar.tintColor = .systemPurple

		tabBar.clipsToBounds = true
		tabBar.layer.borderWidth = 0

	}

}
