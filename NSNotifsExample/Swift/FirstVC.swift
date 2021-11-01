import UIKit


class FirstVC: UIViewController {

	/*--- instantiate UIButton so we can access all 
	of it's properties and create our button ---*/

	var magicButton = UIButton()

	override func viewDidLoad() {

		super.viewDidLoad() // call the original implementation of viewDidLoad()

		// create our button

		magicButton = UIButton()
		magicButton.setTitle("Tap me and switch tabs to see magic", for: .normal)
		magicButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
		magicButton.backgroundColor = .systemIndigo
		magicButton.layer.cornerCurve = .continuous
		magicButton.layer.cornerRadius = 20
		magicButton.translatesAutoresizingMaskIntoConstraints = false
		magicButton.addTarget(self, action:#selector(notificationSender), for: .touchUpInside)
		view.addSubview(magicButton)

		// call our setupLayout method, yes it's called method here because it's within the scope of our class

		setupLayout()

	}

	private func setupLayout() {

		// proper UI layout

		magicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		magicButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		magicButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
		magicButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

	}

	/*--- we use @objc because "selector" is an Objective-C concept only,
	so we need to make it visible to the Objective-C runtime ---*/

	@objc private func notificationSender() {

		// fire the notification when clicking the button

		NotificationCenter.default.post(name: Notification.Name("fireNotificationDone"), object: nil)
		
	}

}
