import Foundation


final class TaskManager {

	static let sharedInstance = TaskManager()

	var outputString: String?

	private init() {}

	func launchTask(withArguments arguments: [String]) {

		let pipe = Pipe()
		let task = NSTask()

		task.arguments = arguments
		task.launchPath = "/bin/sh"
		task.standardOutput = pipe
		task.launch()

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		outputString = String(data: data, encoding: .utf8)

	}

}
