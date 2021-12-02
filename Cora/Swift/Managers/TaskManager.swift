import Foundation


final class TaskManager {
	
	static let sharedInstance = TaskManager()
	var darwinString: String?
	var uptimeString: String?
	
	private init() {}
	
	func launchDarwinTask() {

		UserDefaultsManager.sharedInstance.loadSwitchState()

		guard let switchState = UserDefaultsManager.sharedInstance.switchState else {
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
