import UIKit


final class FirstVC: UIViewController {

	/*--- instantiate UIButton so we can access all 
	of it's properties and create our button ---*/

	private let magicButton: UIButton = {
		let button = UIButton()
		button.setTitle("Tap me and switch tabs to see magic", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action:#selector(didTapMagicButton), for: .touchUpInside)
		return button
	}()

	private let buttonGradientLayer: CAGradientLayer = {
		let gradientLayer = CAGradientLayer()
		let firstColor = UIColor(red: 0.74, green: 0.78, blue: 0.98, alpha: 1.0)
		let secondColor = UIColor(red: 0.77, green: 0.69, blue: 0.91, alpha: 1.0)
		let gradientColors = [firstColor.cgColor, secondColor.cgColor]
		gradientLayer.colors = gradientColors
		gradientLayer.frame = CGRect(x: 0, y: 0, width: 260, height: 40)
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.cornerCurve = .continuous
		gradientLayer.cornerRadius = 20
		return gradientLayer
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
		magicButton.layer.insertSublayer(buttonGradientLayer, at: 0)

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

	@objc private func didTapMagicButton() {

		// fire the notification when clicking the button

		NotificationCenter.default.post(name: Notification.Name("fireNotificationDone"), object: nil)

	}

}
