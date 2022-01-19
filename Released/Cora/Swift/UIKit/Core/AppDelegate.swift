import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	let colorManager = ColorManager()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window!.rootViewController = UINavigationController(rootViewController: UPTRootVC())
		window!.makeKeyAndVisible()

		colorManager.loadInitialAccentColor()
	
		return true
	}

}
