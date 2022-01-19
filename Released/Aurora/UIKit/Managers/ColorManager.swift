import UIKit


final class ColorManager {

	static let sharedInstance = ColorManager()

	init() {}
	
	func setAccentColor() -> UIColor {

		return UIColor(red: 0.74, green: 0.78, blue: 0.98, alpha: 1.0)

	}

}
