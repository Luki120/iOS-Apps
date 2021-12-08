import UIKit


final class GlobalManager {

	static let sharedInstance = GlobalManager()

	let commandSwitch: UISwitch = {
		let theSwitch = UISwitch()
		return theSwitch
	}()

	init() {}

}
