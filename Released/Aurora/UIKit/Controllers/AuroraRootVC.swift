import UIKit


final class AuroraRootVC: UITabBarController {

	private let auroraVC = AuroraVC()
	private let dummyVC = UIViewController()
	private lazy var firstNav = UINavigationController(rootViewController: auroraVC)
	private lazy var secondNav = UINavigationController(rootViewController: dummyVC)

	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		auroraVC.title = "Aurora"
		dummyVC.title = "Vault"

		firstNav.tabBarItem = UITabBarItem(title: "Aurora", image: UIImage(systemName: "house.fill"), tag: 0)
		secondNav.tabBarItem = UITabBarItem(title: "Vault", image: UIImage(systemName: "lock.fill"), tag: 1)

		viewControllers = [firstNav, secondNav]

	}

	override func viewDidLoad() {

		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = .systemBackground

		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

		tabBar.barTintColor = .systemBackground
		tabBar.isTranslucent = false

		tabBar.clipsToBounds = true
		tabBar.layer.borderWidth = 0

	}

}
