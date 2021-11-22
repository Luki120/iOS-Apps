import UIKit


final class UserDefaultsManager {

	static let sharedInstance = UserDefaultsManager()

	let colorManager = ColorManager.sharedInstance
	let globalManager = GlobalManager.sharedInstance

	var switchState:Bool?

	init() {}

 	func loadSwitchState() {

		switchState = UserDefaults.standard.bool(forKey: "switchState")

	}

	func setSwitchState() {

		globalManager.commandSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState"), animated: true)
		
	}

	func saveSwitchState() {

		UserDefaults.standard.set(globalManager.commandSwitch.isOn, forKey: "switchState")

	}

	func loadAccentColor() {

		do {

			let decodedData = UserDefaults.standard.object(forKey: "accentColor")

			guard let data = decodedData as? Data else {
				return
			}

			guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
				return
			}

			colorManager.accentColor = color

		}

		catch {

			print("handling the fucking error so this shit lets me compile")
			return

		}

	}

	func saveAccentColor() {

		do {

			let encodedData = try NSKeyedArchiver.archivedData(withRootObject: colorManager.accentColor, requiringSecureCoding: false)
			UserDefaults.standard.set(encodedData, forKey: "accentColor")

		}

		catch {

			print("handling the fucking error so this shit lets me compile")
			return

		}

	}

}
