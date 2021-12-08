import Foundation
import SwiftUI


final class TaskManager: ObservableObject {

	static let sharedInstance = TaskManager()

	@Published var darwinString: String?
	@Published var uptimeString: String?
	
	init() {}
	
	func launchDarwinTask() {

		let darwinTask = NSTask()
		darwinTask.arguments = ["-c", "uname -a"]
		darwinTask.launchPath = "/bin/sh"
		
		let pipe = Pipe()
		darwinTask.standardOutput = pipe
		darwinTask.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		darwinString = String(data: data, encoding: .utf8)

	}

	func launchUptimeTask() {

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
