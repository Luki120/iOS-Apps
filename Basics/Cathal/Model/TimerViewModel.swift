import SwiftUI


final class TimerViewModel: ObservableObject {

	@Published private(set) var progress: CGFloat = 1	
	@Published private(set) var timerString = "00:00"
	@Published var isActive = false
	@Published var startNewTimer = false

	@Published var minutes = 0
	@Published var seconds = 0
	@Published var breakMinutes = 0
	@Published var breakSeconds = 0

	@Published var totalSeconds = 0
	@Published private(set) var totalStaticSeconds = 0

	@Published var isFinished = false
	@Published private(set) var shouldStartBreak = false

	let sessionIntervals = ["15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
	let breakIntervals = ["5", "10", "15", "20", "25", "30"]

	func startTimer() {
		startTimerWith(minutes, seconds, passingFlag: &isActive)
	}

	func stopTimer() {
		withAnimation {
			isActive = false
			shouldStartBreak = false
			minutes = 0
			seconds = 0
			breakMinutes = 0
			breakSeconds = 0
			progress = 1
		}
		totalSeconds = 0
		totalStaticSeconds = 0
		timerString = "00:00"
	}

	func updateTimer() {
		updateTimerWith(&minutes, &seconds, isInBreak: false)
		if minutes == 0 && seconds == 0 {
			isActive = false
			isFinished = true
			startTimerWith(breakMinutes, breakSeconds, passingFlag: &shouldStartBreak)
		}
	}

	private func startTimerWith(_ min: Int, _ secs: Int, passingFlag flag: inout Bool) {
		withAnimation(.easeInOut(duration: 1.0)) { flag = true }
		timerString = "\(min):\(secs < 10 ? "0" : "")\(secs)"

		totalSeconds = (min * 60) + secs
		totalStaticSeconds = totalSeconds
		startNewTimer = false
	}

	func updateTimerWith(_ min: inout Int, _ secs: inout Int, isInBreak: Bool) {
		progress = CGFloat(totalSeconds) / CGFloat(totalStaticSeconds)
		progress = progress < 0 ? 0 : progress
		totalSeconds -= 1
		min = (totalSeconds / 60) % 60
		secs = totalSeconds % 60
		timerString = "\(min):\(secs < 10 ? "0" : "")\(secs)"
		guard isInBreak else { return }
 		if min == 0 && secs == 0 {
			isActive = false
			isFinished = true
			shouldStartBreak = false
		}
	}
}
