import UIKit


final class TabBarVC : UITabBarController {

	// instantiate our view controllers, would be something like this in objC --> [FirstVC new];

	let firstVC = FirstVC()
	let secondVC = SecondVC()

	// create our navigation controllers

	lazy var firstNav = UINavigationController(rootViewController: firstVC)
	lazy var secondNav = UINavigationController(rootViewController: secondVC)

	required init?(coder aDecoder: NSCoder) {

	    super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		// give our navigation bar titles

		firstVC.title = "Home"
		secondVC.title = "Not Home"

		// create our UITabBarItems

		firstNav.tabBarItem = UITabBarItem(title: "Home", image:UIImage(systemName: "bolt.horizontal.fill"), tag:0)
		secondNav.tabBarItem = UITabBarItem(title: "Not Home", image:UIImage(systemName: "bonjour"), tag:1)

		// let the tab bar controller know of the view controllers we want to display

		setViewControllers([firstNav, secondNav], animated: false)

	}

	override func viewDidLoad() {

		super.viewDidLoad()

		// do any additional setup after loading the view, typically from a nib.

		// customization

		firstNav.navigationBar.shadowImage = UIImage()
		firstNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

		secondNav.navigationBar.shadowImage = UIImage()
		secondNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

		tabBar.barTintColor = .systemBackground
		tabBar.isTranslucent = false

		tabBar.tintColor = .systemPurple

		tabBar.clipsToBounds = true
		tabBar.layer.borderWidth = 0

	}

}
