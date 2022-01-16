import UIKit
import SafariServices


final class SettingsVC: UITableViewController {

	private let accentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 15)
		label.text = "Change Accent Color"
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints	= false
		return label
	}()

	private let darwinLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 15)
		label.text = "Print Darwin Information" 
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let indicatorView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.borderColor = UIColor.white.cgColor
		view.layer.borderWidth = 2
		view.layer.cornerRadius = 15
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let indicatorShapeLayer: CAShapeLayer = {
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).cgPath
		return shapeLayer
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
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

	private let uptRootVC = UPTRootVC()
	private let colorPicker = UIColorPickerViewController()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {

		super.init(nibName: nil, bundle: nil)

		setupUI()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VanillaCell")

		GlobalManager.sharedInstance.commandSwitch.addTarget(self, action: #selector(switchStateChanged), for: .valueChanged)

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

		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		GlobalManager.sharedInstance.commandSwitch.onTintColor = ColorManager.sharedInstance.accentColor

		accentLabel.textColor = ColorManager.sharedInstance.accentColor
		indicatorShapeLayer.fillColor = ColorManager.sharedInstance.accentColor.cgColor

		sourceCodeButton.setTitleColor(ColorManager.sharedInstance.accentColor, for: .normal)
		copyrightLabel.textColor = ColorManager.sharedInstance.accentColor

		tableView.separatorStyle = .none

		setupPicker()
		setupStackView()

	}

	private func setupPicker() {

		colorPicker.delegate = self
		colorPicker.selectedColor = ColorManager.sharedInstance.accentColor
		colorPicker.modalPresentationStyle = .popover

	}

	private func setupStackView() {

		view.addSubview(stackView)
		stackView.addArrangedSubview(sourceCodeButton)
		stackView.addArrangedSubview(copyrightLabel)

		let guide = view.safeAreaLayoutGuide

		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20).isActive = true

	}

	// MARK: - Actions

	@objc private func switchStateChanged() {

		UserDefaultsManager.sharedInstance.saveSwitchState()

		NotificationCenter.default.post(name: Notification.Name("launchChosenTask"), object: nil)

	}

	@objc private func didTapSourceCodeButton() {

		let url = URL(string: "https://github.com/Luki120/iOS-Apps/tree/main/Cora")

		guard let theURL = url else {
			return
		}

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

				darwinLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
				darwinLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true

			case 1:

				cell.contentView.addSubview(accentLabel)

				accentLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
				accentLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true

				cell.contentView.addSubview(indicatorView)
				indicatorView.layer.addSublayer(indicatorShapeLayer)

				indicatorView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
				indicatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -28).isActive = true
				indicatorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
				indicatorView.heightAnchor.constraint(equalToConstant: 30).isActive = true

			default: break

		}

		return cell

	}

}


extension SettingsVC {

	// MARK: - Table View Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		if indexPath.row == 1 { present(colorPicker, animated: true, completion: nil) }

	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let headerView = UIView()
		return headerView

	}

}


extension SettingsVC: SFSafariViewControllerDelegate, UIColorPickerViewControllerDelegate {

	// MARK: - UIColorPickerViewControllerDelegate

	func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {

		ColorManager.sharedInstance.accentColor = viewController.selectedColor

		darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		GlobalManager.sharedInstance.commandSwitch.onTintColor = ColorManager.sharedInstance.accentColor
		accentLabel.textColor = ColorManager.sharedInstance.accentColor

		indicatorShapeLayer.fillColor = ColorManager.sharedInstance.accentColor.cgColor

		sourceCodeButton.setTitleColor(ColorManager.sharedInstance.accentColor, for: .normal)
		copyrightLabel.textColor = ColorManager.sharedInstance.accentColor

		uptRootVC.darwinLabel.textColor = ColorManager.sharedInstance.accentColor
		uptRootVC.uptimeLabel.textColor = ColorManager.sharedInstance.accentColor
		uptRootVC.settingsButton.tintColor = ColorManager.sharedInstance.accentColor	

		NotificationCenter.default.post(name: Notification.Name("updateAccentColors"), object: nil)

		UserDefaultsManager.sharedInstance.saveAccentColor()

	}

}
