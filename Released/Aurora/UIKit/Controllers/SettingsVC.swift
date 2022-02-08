import UIKit
import SafariServices


final class SettingsVC: UITableViewController {

	private let cellIdentifier = "Cell"

	private var settingsOptions = [
		"A-Z",
		"0-9",
		"!@#$%^&*",
		"Only uppercase",
		"Only numbers",
		"Only special characters",
		""
	]

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
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15.5)
		button.addTarget(self, action: #selector(didTapSourceCodeButton), for: .touchUpInside)
		return button
	}()

	private let copyrightLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 10)
		label.text = "Luki120 © 2021"
		label.textColor = .gray
		return label
	}()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {

		super.init(nibName: nil, bundle: nil)

		setupUI()

	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

		super.traitCollectionDidChange(previousTraitCollection)

		tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white

	}

	private func setupUI() {

		tableView.separatorStyle = .none
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

	}

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
		aSwitch.onTintColor = ColorManager.sharedInstance.setAccentColor()
		aSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

		configureSwitches()

		cell.accessoryView = aSwitch

 		if indexPath.row == 6 {

			cell.accessoryView = nil

			cell.contentView.addSubview(footerStackView)
			footerStackView.addArrangedSubview(sourceCodeButton)
			footerStackView.addArrangedSubview(copyrightLabel)

			footerStackView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
			footerStackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true

		}

		return cell

	}

	private func configureSwitches() {

		for _ in 0..<settingsOptions.count {

			switch aSwitch.tag {

				case 0: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState"), animated: true)

				case 1: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState1"), animated: true)

				case 2: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState2"), animated: true)

				case 3: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState3"), animated: true)

				case 4: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState4"), animated: true)

				case 5: aSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState5"), animated: true)

				default: break

			}

		}

	}

	// MARK: Table View Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let headerView = UIView()
		headerView.backgroundColor = .clear
		return headerView

	}

 	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		if indexPath.row == 6 { return 200 }

		return 44

	}

}


// MARK: - Selectors

extension SettingsVC: SFSafariViewControllerDelegate {

	@objc private func switchValueChanged(_ sender: UISwitch) {

		switch sender.tag {

			case 0: UserDefaults.standard.set(sender.isOn, forKey: "switchState")

			case 1: UserDefaults.standard.set(sender.isOn, forKey: "switchState1")

			case 2: UserDefaults.standard.set(sender.isOn, forKey: "switchState2")

			case 3: UserDefaults.standard.set(sender.isOn, forKey: "switchState3")

			case 4: UserDefaults.standard.set(sender.isOn, forKey: "switchState4")

			case 5: UserDefaults.standard.set(sender.isOn, forKey: "switchState5")

			default: break

		}

	}

	@objc private func didTapSourceCodeButton() {

		let url = URL(string: "https://github.com/Luki120/iOS-Apps/tree/main/Released/Aurora")

		guard let sourceCodeURL = url else {
			return
		}

		let safariVC = SFSafariViewController(url: sourceCodeURL)
		safariVC.delegate = self
		present(safariVC, animated: true, completion: nil)

	}

}
