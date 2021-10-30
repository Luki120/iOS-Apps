import UIKit


class TabBarVC : UITabBarController {

	override func viewDidLoad() {

		super.viewDidLoad()
		delegate = self

		// create UITabBarItems

		let firstItem = FirstVC() // instantiate FirstVC, would be something like this in objC --> [FirstVC new];
		let firstImage = UITabBarItem(title: "Home", image:UIImage(systemName: "bolt.horizontal.fill"), selectedImage: UIImage(systemName: "bolt.horizontal.fill"))
		firstItem.tabBarItem = firstImage

		let secondItem = SecondVC()
		let secondImage = UITabBarItem(title: "Not Home", image:UIImage(systemName: "bonjour"), selectedImage: UIImage(systemName: "bonjour"))
		secondItem.tabBarItem = secondImage

		// let the tab bar controller know of the controllers we want to display

		let controllers = [firstItem, secondItem] // array containing our UITabBarItems
		self.viewControllers = controllers

		// customization

		tabBar.barTintColor = .black
		tabBar.isTranslucent = false

		tabBar.tintColor = .systemPurple
		tabBar.clipsToBounds = true

		// get rid of the border line

		tabBar.layer.borderWidth = 0

	}

}
