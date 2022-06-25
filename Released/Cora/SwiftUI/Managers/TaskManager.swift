import Foundation
import SwiftUI


final class TaskManager: ObservableObject {

	@AppStorage("switchState") var shouldPrintDarwinInformation = false

	@Published var outputString: String?

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
