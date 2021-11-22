import UIKit
import SafariServices


final class SettingsVC: UITableViewController {

	private let cellIdentifier = "cell"
	let colorManager = ColorManager.sharedInstance
	let globalManager = GlobalManager.sharedInstance
	let userDefaultsManager = UserDefaultsManager.sharedInstance

	let uptRootVC = UPTRootVC()

	private let accentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 15.5)
		label.text = "Change Accent Color"
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints	= false
		return label
	}()

	private let darwinLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Courier", size: 15.5)
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
		label.text = "2021 © Luki120"
		label.textAlignment = .center
		return label
	}()

	let colorPicker: UIColorPickerViewController = {
		let picker = UIColorPickerViewController()
		return picker
	}()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {

		super.init(nibName: nil, bundle: nil)

		userDefaultsManager.loadAccentColor()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

		globalManager.commandSwitch.addTarget(self, action: #selector(switchStateChanged), for: .valueChanged)

		setupUI()
		setupPicker()

	}

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		userDefaultsManager.setSwitchState()

	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

		super.traitCollectionDidChange(previousTraitCollection)

		traitCollection.userInterfaceStyle == .dark ? (view.backgroundColor = .black) : (view.backgroundColor = .white)

	}

	private func setupUI() {

		darwinLabel.textColor = colorManager.accentColor
		globalManager.commandSwitch.onTintColor = colorManager.accentColor

		accentLabel.textColor = colorManager.accentColor
		indicatorShapeLayer.fillColor = colorManager.accentColor.cgColor

		sourceCodeButton.setTitleColor(colorManager.accentColor, for: .normal)
		copyrightLabel.textColor = colorManager.accentColor

		view.backgroundColor = .black
		tableView.separatorStyle = .none

	}

	private func setupPicker() {

		colorPicker.delegate = self
		colorPicker.selectedColor = colorManager.accentColor
		colorPicker.modalPresentationStyle = .popover

	}

	@objc private func switchStateChanged() {

		userDefaultsManager.saveSwitchState()

		NotificationCenter.default.post(name: Notification.Name("launchChosenTask"), object: nil)

	}

	// Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 3

	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell.selectionStyle = .none
		cell.backgroundColor = .black

		switch indexPath.row {

			case 0:

				cell.contentView.addSubview(darwinLabel)

				cell.accessoryView = globalManager.commandSwitch

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

			case 2:

				cell.contentView.addSubview(stackView)
				stackView.addArrangedSubview(sourceCodeButton)
				stackView.addArrangedSubview(copyrightLabel)

				stackView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
				stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true

			default:

				break

		}

		return cell

	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		if indexPath.row == 1 {

			present(colorPicker, animated: true, completion: nil)

		}

	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let headerView = UIView()
		headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
		return headerView

	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		if indexPath.row == 2 {
			return 120
		}

		return 44

	}

}

extension SettingsVC: SFSafariViewControllerDelegate, UIColorPickerViewControllerDelegate {

	// delegate methods

	func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {

		colorManager.accentColor = viewController.selectedColor

		darwinLabel.textColor = colorManager.accentColor
		globalManager.commandSwitch.onTintColor = colorManager.accentColor
		accentLabel.textColor = colorManager.accentColor

		indicatorShapeLayer.fillColor = colorManager.accentColor.cgColor

		sourceCodeButton.setTitleColor(colorManager.accentColor, for: .normal)
		copyrightLabel.textColor = colorManager.accentColor
		
		uptRootVC.darwinLabel.textColor = colorManager.accentColor
		uptRootVC.uptimeLabel.textColor = colorManager.accentColor
		uptRootVC.settingsButton.tintColor = colorManager.accentColor	

		/*--- for some reason the colors on the main page didn't update instantly,
		so notifications it is, :bthishowitis: ---*/

		NotificationCenter.default.post(name: Notification.Name("updateAccentColor"), object: nil)

		userDefaultsManager.saveAccentColor()

	}

	@objc private func didTapSourceCodeButton() {

		let url = URL(string: "https://github.com/Luki120/iOS-Apps/tree/main/Cora")

		guard let theURL = url else {
			return
		}

		let safariVC = SFSafariViewController(url: theURL)
		safariVC.delegate = self
		present(safariVC, animated: true, completion: nil)

	}

}
