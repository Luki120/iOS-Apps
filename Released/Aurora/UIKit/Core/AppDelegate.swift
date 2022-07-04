import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.tintColor = UIColor.auroraColor
		window?.rootViewController = AuroraRootVC()
		window?.makeKeyAndVisible()
		return true
	}

}
