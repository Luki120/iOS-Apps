import Foundation


final class TaskManager {
	
	static let sharedInstance = TaskManager()
	var darwinString: String?
	var uptimeString: String?

	let userDefaultsManager = UserDefaultsManager.sharedInstance
	
	private init() {}
	
	func launchDarwinTask() {

		userDefaultsManager.loadSwitchState()

		guard let switchState = userDefaultsManager.switchState else {
			return
		}

		if !switchState {
			return
		}

		let darwinTask = NSTask()
		darwinTask.arguments = ["-c", "uname -a"]
		darwinTask.launchPath = "/bin/sh"
		
		let pipe = Pipe()
		darwinTask.standardOutput = pipe
		darwinTask.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		darwinString = String(data: data, encoding: .utf8)

	}

	func launchUptimeTask () {

		let uptimeTask = NSTask()
		uptimeTask.arguments = ["-c", "uptime"]
		uptimeTask.launchPath = "/bin/sh"
		
		let pipe = Pipe()
		uptimeTask.standardOutput = pipe
		uptimeTask.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		uptimeString = String(data: data, encoding: .utf8)

	}

}
