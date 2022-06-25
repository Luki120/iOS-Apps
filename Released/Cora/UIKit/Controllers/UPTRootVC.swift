import UIKit


final class UPTRootVC: UIViewController {

	let settingsButton: UIButton = {
		let button = UIButton()
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

		super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		setupDefaults()
		setupUI()
		setupObservers()

		settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)

		Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateUptimeText), userInfo: nil, repeats: true)

	}

	private func setupDefaults() {

		UserDefaultsManager.sharedInstance.loadAccentColor()
		UserDefaultsManager.sharedInstance.loadSwitchState()

		guard let switchState = UserDefaultsManager.sharedInstance.switchState else {
			return
		}

		guard switchState else { return }

		setDarwinText()

	}

	private func setupObservers() {

		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(setDarwinText), name: Notification.Name("launchChosenTask"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccentColors), name: Notification.Name("updateAccentColors"), object: nil)

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

	private func setupUI() {

		view.addSubview(uptimeLabel)
		view.addSubview(darwinLabel)
		view.addSubview(settingsButton)

		uptimeLabel.text = setUptimeText()
		animateUptimeLabel()

		let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
		navigationItem.rightBarButtonItem = settingsButtonItem

		updateAccentColors()

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

	@objc private func didTapSettingsButton() {

		let settingsVC = SettingsVC()
		present(settingsVC, animated: true)

	}

	private func animateUptimeLabel() {

		uptimeLabel.text = ""
		let finalText = TaskManager.sharedInstance.outputString ?? ""
		var charIndex = 0.0

		for letter in finalText {
			Timer.scheduledTimer(withTimeInterval: 0.020 * charIndex, repeats: false) { timer in
				self.uptimeLabel.text?.append(letter)
			}
			charIndex += 1
		}

	}

	private func setUptimeText() -> String {

		TaskManager.sharedInstance.launchTask(withArguments: ["-c", "uptime"])

		let uptimeString = TaskManager.sharedInstance.outputString ?? ""

		return uptimeString

	}

	// MARK: - NSNotificationCenter

	@objc private func setDarwinText() {

		UserDefaultsManager.sharedInstance.loadSwitchState()

		guard let switchState = UserDefaultsManager.sharedInstance.switchState else {
			return
		}

		guard switchState else {
			darwinLabel.text = nil
			return 
		}

		TaskManager.sharedInstance.launchTask(withArguments: ["-c", "uname -a"])

		let darwinString = TaskManager.sharedInstance.outputString ?? ""

		darwinLabel.text = darwinString

	}

	@objc private func updateAccentColors() {

 		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		uptimeLabel.textColor = ColorManager.sharedInstance.accentColor
		settingsButton.tintColor = ColorManager.sharedInstance.accentColor

	}

	// MARK: - NSTimer

	@objc private func updateUptimeText() {

		uptimeLabel.text = setUptimeText()

	}

}
