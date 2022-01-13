import Foundation
import SwiftUI


final class TaskManager: ObservableObject {

	@AppStorage("switchState") var shouldPrintDarwinInformation = false

	@Published var darwinString: String?
	@Published var uptimeString: String?

	init() {
		launchTask()
	}

	func launchTask() {

		let task = NSTask()
		task.arguments = ["-c", "uptime"]
		task.launchPath = "/bin/sh"

		let pipe = Pipe()
		task.standardOutput = pipe
		task.launch()

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		uptimeString = String(data: data, encoding: .utf8)

		guard shouldPrintDarwinInformation else { return }

		let darwinTask = NSTask()
		darwinTask.arguments = ["-c", "uname -a"]
		darwinTask.launchPath = "/bin/sh"

		let darwinPipe = Pipe()
		darwinTask.standardOutput = darwinPipe
		darwinTask.launch()

		let darwinData = darwinPipe.fileHandleForReading.readDataToEndOfFile()
		darwinString = String(data: darwinData, encoding: .utf8)

	}

}
