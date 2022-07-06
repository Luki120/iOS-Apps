import UIKit


final class ColorManager {

	static let sharedInstance = ColorManager()
	var accentColor = UIColor.green

	private init() {}

	func loadInitialAccentColor() {
		do {
			let encodedData = try NSKeyedArchiver.archivedData(withRootObject: accentColor, requiringSecureCoding: false)
			let defaultAccentColor = ["accentColor": encodedData]
			UserDefaults.standard.register(defaults: defaultAccentColor)
		}
		catch { return }
	}

}
