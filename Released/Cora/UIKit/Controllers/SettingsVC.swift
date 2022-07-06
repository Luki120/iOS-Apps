import UIKit
import SafariServices


final class SettingsVC: UITableViewController, SFSafariViewControllerDelegate {

	private lazy var colorWell: UIColorWell = {
		let colorWell = UIColorWell()
		colorWell.translatesAutoresizingMaskIntoConstraints = false
		colorWell.addTarget(self, action: #selector(colorWellDidChange), for: .valueChanged)
		return colorWell
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		stackView.addArrangedSubview(sourceCodeButton)
		stackView.addArrangedSubview(copyrightLabel)
		return stackView
	}()

	private let sourceCodeButton: UIButton = {
		let button = UIButton()
		button.alpha = 0.5
		button.titleLabel?.font = UIFont(name: "Courier", size: 15.5)
		button.setTitle("Source Code", for: .normal)
		button.addTarget(self, action: #selector(didTapSourceCodeButton), for: .touchUpInside)
		return button
	}()

	private let copyrightLabel: UILabel = {
		let label = UILabel()
		label.alpha = 0.5
		label.font = UIFont(name: "Courier", size: 10)
		label.text = "2022 © Luki120"
		label.textAlignment = .center
		return label
	}()

	private var accentLabel: UILabel!
	private var darwinLabel: UILabel!

	private let uptRootVC = UPTRootVC()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil)

		setupUI()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VanillaCell")
		GlobalManager.sharedInstance.commandSwitch.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UserDefaultsManager.sharedInstance.setSwitchState()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
	}

	private func setupUI() {
		UserDefaultsManager.sharedInstance.loadAccentColor()

		accentLabel = createLabel(withText: "Change Accent Color")
		darwinLabel = createLabel(withText: "Print Darwin Information")

		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		GlobalManager.sharedInstance.commandSwitch.onTintColor = ColorManager.sharedInstance.accentColor

		accentLabel.textColor = ColorManager.sharedInstance.accentColor
		colorWell.selectedColor = ColorManager.sharedInstance.accentColor

		sourceCodeButton.setTitleColor(ColorManager.sharedInstance.accentColor, for: .normal)
		copyrightLabel.textColor = ColorManager.sharedInstance.accentColor

		tableView.separatorStyle = .none

		setupStackViewConstraints()
	}

	private func setupStackViewConstraints() {
		let guide = view.safeAreaLayoutGuide

		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30).isActive = true
	}

	// MARK: - Reusable

	private func createLabel(withText text: String) -> UILabel {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 15)
		label.text = text
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints	= false
		return label
	}

	private func setupConstraintsForLabel(_ label: UILabel, constrainedTo cell: UITableViewCell) {
		label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
		label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true
	}

	// MARK: - Selectors

	@objc private func colorWellDidChange() {
		ColorManager.sharedInstance.accentColor = colorWell.selectedColor ?? .systemTeal

		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		GlobalManager.sharedInstance.commandSwitch.onTintColor = ColorManager.sharedInstance.accentColor
		accentLabel.textColor = ColorManager.sharedInstance.accentColor

		sourceCodeButton.setTitleColor(ColorManager.sharedInstance.accentColor, for: .normal)
		copyrightLabel.textColor = ColorManager.sharedInstance.accentColor

 		uptRootVC.darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		uptRootVC.uptimeLabel.textColor = ColorManager.sharedInstance.accentColor
		uptRootVC.settingsButton.tintColor = ColorManager.sharedInstance.accentColor

		NotificationCenter.default.post(name: Notification.Name("updateAccentColors"), object: nil)
		UserDefaultsManager.sharedInstance.saveAccentColor()

	}

	@objc private func switchStateDidChange() {
		UserDefaultsManager.sharedInstance.saveSwitchState()
		NotificationCenter.default.post(name: Notification.Name("launchChosenTask"), object: nil)
	}

	@objc private func didTapSourceCodeButton() {
		let url = URL(string: "https://github.com/Luki120/iOS-Apps/tree/main/Released/Cora")
		guard let theURL = url else { return }

		let safariVC = SFSafariViewController(url: theURL)
		safariVC.delegate = self
		safariVC.modalPresentationStyle = .pageSheet
		present(safariVC, animated: true, completion: nil)
	}

}


extension SettingsVC {

	// MARK: - Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "VanillaCell", for: indexPath)

		cell.selectionStyle = .none
		cell.backgroundColor = .clear

		switch indexPath.row {

			case 0:

				cell.contentView.addSubview(darwinLabel)
				cell.accessoryView = GlobalManager.sharedInstance.commandSwitch
				setupConstraintsForLabel(darwinLabel, constrainedTo: cell)

			case 1:

				cell.contentView.addSubview(accentLabel)
				cell.contentView.addSubview(colorWell)
				setupConstraintsForLabel(accentLabel, constrainedTo: cell)

 				colorWell.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
				colorWell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -28).isActive = true

			default: break

		}

		return cell
	}

}


extension SettingsVC {

	// MARK: - Table View Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		return headerView
	}

}
