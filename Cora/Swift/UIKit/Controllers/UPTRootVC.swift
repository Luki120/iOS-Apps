import UIKit


final class UPTRootVC: UIViewController {

	let settingsButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(systemName: "gear"), for: .normal)
		return button
	}()

	let darwinLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 12)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let uptimeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 16)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	required init?(coder aDecoder: NSCoder) {

		fatalError("init(coder:) has not been implemented")

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		UserDefaultsManager.sharedInstance.loadAccentColor()

		setupUI()
		launchChosenTask()
		animateUptimeLabel()

		settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)

		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(launchChosenTask), name: Notification.Name("launchChosenTask"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(setupUI), name: Notification.Name("updateAccentColor"), object: nil)

		Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(launchChosenTask), userInfo: nil, repeats: true)

	}

	override func viewDidLoad() {

		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = UIColor.systemBackground

		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

		layoutUI()

	}

	@objc private func setupUI() {

 		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		uptimeLabel.textColor = ColorManager.sharedInstance.accentColor
		settingsButton.tintColor = ColorManager.sharedInstance.accentColor

		view.addSubview(darwinLabel)
		view.addSubview(uptimeLabel)
		view.addSubview(settingsButton)

		let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
		navigationItem.rightBarButtonItem = settingsButtonItem

	}

	private func layoutUI() {

		let safeInsetsBottom = view.safeAreaInsets.bottom

		guard let view = view else {
			return
		}

		let views = [

			"darwinLabel": darwinLabel,
			"uptimeLabel": uptimeLabel,
			"superview": view

		]

		let formatCenterX = "V:[superview]-(<=1)-[uptimeLabel]"
		let formatCenterY = "H:[superview]-(<=1)-[uptimeLabel]"
		let formatLeadingTrailing = "H:|-10-[uptimeLabel]-10-|"

		let darwinFormatBottom = "V:[darwinLabel]-\(safeInsetsBottom)-|"
		let darwinFormatCenterX = "V:[superview]-(<=1)-[darwinLabel]"
		let darwinFormatLeadingTrailing = "H:|-10-[darwinLabel]-10-|"

		let centerXConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCenterX, options: [.alignAllCenterX], metrics: nil, views: views)
		let centerYConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCenterY, options: [.alignAllCenterY], metrics: nil, views: views)
		let leadingTrailingConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatLeadingTrailing, options: [], metrics: nil, views: views)

		let darwinBottomConstraint = NSLayoutConstraint.constraints(withVisualFormat: darwinFormatBottom, options: [], metrics: nil, views: views)
		let darwinCenterXConstraint = NSLayoutConstraint.constraints(withVisualFormat: darwinFormatCenterX, options: [.alignAllCenterX], metrics: nil, views: views)
		let darwinLeadingTrailingConstraint = NSLayoutConstraint.constraints(withVisualFormat: darwinFormatLeadingTrailing, options: [], metrics: nil, views: views)

		view.addConstraints(centerXConstraint + centerYConstraint + leadingTrailingConstraint) 
		view.addConstraints(darwinBottomConstraint + darwinCenterXConstraint + darwinLeadingTrailingConstraint)

	}

	private func animateUptimeLabel() {

		uptimeLabel.text = ""
		let finalText = TaskManager.sharedInstance.uptimeString
		var charIndex = 0.0

		for letter in finalText ?? "" {
			Timer.scheduledTimer(withTimeInterval: 0.020 * charIndex, repeats: false) { (timer) in
				self.uptimeLabel.text?.append(letter)
			}
			charIndex += 1
		}

	}

	@objc private func launchChosenTask() {

		TaskManager.sharedInstance.launchDarwinTask()
		TaskManager.sharedInstance.launchUptimeTask()

		guard let switchState = UserDefaultsManager.sharedInstance.switchState else {
			return
		}

		if !switchState {
			darwinLabel.text = nil
		}

		else {
			darwinLabel.text = TaskManager.sharedInstance.darwinString
		}

		uptimeLabel.text = TaskManager.sharedInstance.uptimeString

	}

	@objc private func didTapSettingsButton() {

		let settingsVC = SettingsVC()
		present(settingsVC, animated: true)

	}

}
