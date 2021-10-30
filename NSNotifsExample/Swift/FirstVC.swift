import UIKit


class FirstVC: UIViewController {

	/*--- instantiate UIButton so we can access all 
	of it's properties and create our button ---*/

	var magicButton = UIButton()

	override func viewDidLoad() {

		super.viewDidLoad() // call the original implementation of viewDidLoad()

		// nav bar color

		navigationController?.navigationBar.barTintColor = UIColor.black
		navigationController?.navigationBar.isTranslucent = false

		// get rid of the border (the gray line)

		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()

		// create our button

		magicButton = UIButton()
		magicButton.setTitle("Tap me and watch the magic on the other side", for: .normal)
		magicButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
		magicButton.backgroundColor = .systemIndigo
		magicButton.layer.cornerRadius = 20
		magicButton.translatesAutoresizingMaskIntoConstraints = false
		magicButton.addTarget(self, action:#selector(self.notificationSender), for: .touchUpInside)
		view.addSubview(magicButton)

		setupLayout() // call our setupLayout function

	}

	private func setupLayout() {

		// proper UI layout

		self.magicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		self.magicButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		self.magicButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
		self.magicButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

	}

	/*--- we use @objc because "selector" is an Objective-C concept only,
	so we need to make it visible to the Objective-C runtime ---*/

	@objc private func notificationSender() {

		// fire the notification when clicking the button

		NotificationCenter.default.post(name: Notification.Name("fireNotificationDone"), object: nil)
		
	}

}
