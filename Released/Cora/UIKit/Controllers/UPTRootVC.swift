import UIKit


final class UPTRootVC: UIViewController {

	lazy var settingsButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "gear"), for: .normal)
		button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
		return button
	}()

	var darwinLabel: UILabel!
	var uptimeLabel: UILabel!

	// MARK: - Lifecycle

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil)

		darwinLabel = createLabel(withFontSize: 12)
		uptimeLabel = createLabel(withFontSize: 16)

		setupDefaults()
		setupUI()
		setupObservers()

		Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateUptimeText), userInfo: nil, repeats: true)
	}

	deinit { NotificationCenter.default.removeObserver(self) }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = .systemBackground

		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layoutUI()
	}

	private func setupDefaults() {
		UserDefaultsManager.sharedInstance.loadAccentColor()
		UserDefaultsManager.sharedInstance.loadSwitchState()

		setDarwinText()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.animateLabel(label: self.darwinLabel, arguments: ["-c", "uname -a"])
		}
	}

	private func setupObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(setDarwinText), name: Notification.Name("launchChosenTask"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccentColors), name: Notification.Name("updateAccentColors"), object: nil)
	}

	private func setupUI() {

		view.addSubview(uptimeLabel)
		view.addSubview(darwinLabel)

		animateLabel(label: uptimeLabel, arguments: ["-c", "uptime"])

		let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
		navigationItem.rightBarButtonItem = settingsButtonItem

		updateAccentColors()

	}

	private func layoutUI() {

		let safeInsetsBottom = view.safeAreaInsets.bottom

		guard let view = view else { return }

 		let views = [
			"darwinLabel": darwinLabel!,
			"uptimeLabel": uptimeLabel!,
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

	private func animateLabel(label: UILabel, arguments: [String]) {
		label.text = ""
		TaskManager.sharedInstance.launchTask(withArguments: arguments)
		let finalText = TaskManager.sharedInstance.outputString
		var charIndex = 0.0

		for letter in finalText {
			Timer.scheduledTimer(withTimeInterval: 0.020 * charIndex, repeats: false) { _ in
				label.text?.append(letter)
			}
			charIndex += 1
		}
	}

	private func setUptimeText() -> String {
		TaskManager.sharedInstance.launchTask(withArguments: ["-c", "uptime"])
		return TaskManager.sharedInstance.outputString
	}

	// MARK: - NSNotificationCenter

	@objc private func setDarwinText() {
		UserDefaultsManager.sharedInstance.loadSwitchState()

		guard UserDefaultsManager.sharedInstance.switchState else {
			darwinLabel.isHidden = true
			return
		}
		darwinLabel.isHidden = false
	}

	@objc private func updateAccentColors() {
 		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		uptimeLabel.textColor = ColorManager.sharedInstance.accentColor
		settingsButton.tintColor = ColorManager.sharedInstance.accentColor
	}

	// MARK: - NSTimer

	@objc private func updateUptimeText() {
		let transition = CATransition()
		transition.type = .fade
		transition.duration = 0.5
		transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		uptimeLabel.layer.add(transition, forKey: nil)
		uptimeLabel.text = setUptimeText()
	}

	// MARK - Reusable

	private func createLabel(withFontSize size: CGFloat) -> UILabel {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: size)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

}
