import UIKit
import SafariServices


final class SettingsVC: UITableViewController {

	private let cellIdentifier = "Cell"

	private var settingsOptions = ["A-Z", "0-9", "!@#$%^&*"]
	private var aSwitch = UISwitch()

	private let footerStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 5
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let sourceCodeButton: UIButton = {
		let button = UIButton()
		button.setTitle("Source Code", for: .normal)
		button.setTitleColor(.gray, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 15.5)
		return button
	}()

	private let copyrightLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 10)
		label.text = "2022 © Luki120"
		label.textColor = .gray
		return label
	}()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(style: .grouped)
		commonInit()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
	}

	private func commonInit() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
		sourceCodeButton.addTarget(self, action: #selector(didTapSourceCodeButton), for: .touchUpInside)

		view.addSubview(footerStackView)
		footerStackView.addArrangedSubview(sourceCodeButton)
		footerStackView.addArrangedSubview(copyrightLabel)

		footerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true

	}

}

extension SettingsVC {

	// MARK: Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return settingsOptions.count

	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		cell.selectionStyle = .none
		cell.backgroundColor = .clear
		cell.textLabel?.text = settingsOptions[indexPath.row]

		aSwitch = UISwitch()
		aSwitch.tag = indexPath.row
		aSwitch.onTintColor = UIColor.auroraColor
		aSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

		configureSwitches()

		cell.accessoryView = aSwitch

		return cell

	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Settings"
	}

	private func configureSwitches() {

		for _ in 0..<settingsOptions.count {

			switch aSwitch.tag {
				case 0: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState1"), animated: true)
				case 1: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState2"), animated: true)
				case 2: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState3"), animated: true)
				default: break
			}

		}

	}

	// MARK: Table View Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}

}

// MARK: Selectors

extension SettingsVC: SFSafariViewControllerDelegate {

	@objc private func switchValueChanged(_ sender: UISwitch) {

		switch sender.tag {
			case 0: UserDefaults.standard.set(sender.isOn, forKey: "switchState1")
			case 1: UserDefaults.standard.set(sender.isOn, forKey: "switchState2")
			case 2: UserDefaults.standard.set(sender.isOn, forKey: "switchState3")
			default: break
		}

		NotificationCenter.default.post(name: Notification.Name("switchValueChanged"), object: nil)

	}

	@objc private func didTapSourceCodeButton() {

		let url = URL(string: "https://github.com/Luki120/iOS-Apps/tree/main/Released/Aurora")

		guard let sourceCodeURL = url else { return }
		let safariVC = SFSafariViewController(url: sourceCodeURL)
		safariVC.delegate = self
		safariVC.modalPresentationStyle = .pageSheet
		present(safariVC, animated: true, completion: nil)

	}

}
