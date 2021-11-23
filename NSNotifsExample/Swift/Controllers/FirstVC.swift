import UIKit


final class FirstVC: UIViewController {

	/*--- instantiate UIButton so we can access all 
	of it's properties and create our button ---*/

	private let magicButton: UIButton = {
		let button = UIButton()
		button.setTitle("Tap me and switch tabs to see magic", for: .normal)
		button.backgroundColor = .systemIndigo
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
		button.layer.cornerCurve = .continuous
		button.layer.cornerRadius = 20
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action:#selector(notificationSender), for: .touchUpInside)
		return button
	}()

 	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		setupUI()

	}

	override func viewDidLoad() {

		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = .systemBackground

	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

		layoutUI()

	}

	private func setupUI() {

		view.addSubview(magicButton)

	}

	private func layoutUI() {

		// proper UI layout

		let centerXConstraint = NSLayoutConstraint(item: magicButton, attribute: .centerX, relatedBy: .equal, toItem: 
		view, attribute: .centerX, multiplier: 1, constant: 0)

		let centerYConstraint = NSLayoutConstraint(item: magicButton, attribute: .centerY, relatedBy: .equal, toItem:
		view, attribute: .centerY, multiplier: 1, constant: 0)

		let widthConstraint = NSLayoutConstraint(item: magicButton, attribute: .width, relatedBy: .equal, toItem: 
		nil, attribute: .notAnAttribute, multiplier: 1, constant: 260)

		let heightConstraint = NSLayoutConstraint(item: magicButton, attribute: .height, relatedBy: .equal, toItem:
		nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)

		view.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])

	}

	/*--- we use @objc because "selector" is an Objective-C concept only,
	so we need to make it visible to the Objective-C runtime ---*/

	@objc private func notificationSender() {

		// fire the notification when clicking the button

		NotificationCenter.default.post(name: Notification.Name("fireNotificationDone"), object: nil)
		
	}

}
