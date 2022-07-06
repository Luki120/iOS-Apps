import UIKit


final class UserDefaultsManager {

	static let sharedInstance = UserDefaultsManager()
	var switchState = false

	private init() {}

 	func loadSwitchState() {
		switchState = UserDefaults.standard.bool(forKey: "switchState")
	}

	func setSwitchState() {
		GlobalManager.sharedInstance.commandSwitch.setOn(UserDefaults.standard.bool(forKey: "switchState"), animated: true)
	}

	func saveSwitchState() {
		UserDefaults.standard.set(GlobalManager.sharedInstance.commandSwitch.isOn, forKey: "switchState")
	}

	func loadAccentColor() {
		do {
			let decodedData = UserDefaults.standard.object(forKey: "accentColor")
			guard let data = decodedData as? Data else { return }

			guard let unarchivedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
				return
			}

			ColorManager.sharedInstance.accentColor = unarchivedColor
		}
		catch { return }

	}

	func saveAccentColor() {
		do {
			let encodedData = try NSKeyedArchiver.archivedData(withRootObject: ColorManager.sharedInstance.accentColor, requiringSecureCoding: false)
			UserDefaults.standard.set(encodedData, forKey: "accentColor")
		}
		catch { return }
	}

}
