import SwiftUI


final class TimerViewModel: ObservableObject {

	@Published var progress: CGFloat = 1
	@Published var isActive = false
	@Published var isBreakActive = false
	@Published var startNewTimer = false

	@Published var minutes = 0
	@Published var seconds = 0
	@Published var breakMinutes = 0
	@Published var breakSeconds = 0
	@Published var totalSeconds = 0

	@Published private(set) var timerString = "00:00"
	@Published private(set) var totalStaticSeconds = 0

	func startTimer() { startTimerWith(minutes, seconds, passingFlag: &isActive) }
	func startBreakTimer() { startTimerWith(breakMinutes, breakSeconds, passingFlag: &isBreakActive) }

	func stopTimer() {
		withAnimation {
			isActive = false
			isBreakActive = false
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
		guard minutes == 0 && seconds == 0 else { return }
		isActive = false
		startTimerWith(breakMinutes, breakSeconds, passingFlag: &isBreakActive)
	}

	func updateBreakTimer() { updateTimerWith(&breakMinutes, &breakSeconds, isInBreak: true) }

	private func startTimerWith(_ min: Int, _ secs: Int, passingFlag flag: inout Bool) {
		withAnimation(.easeInOut(duration: 1.0)) { flag = true }
		timerString = "\(min):\(secs < 10 ? "0" : "")\(secs)"

		totalSeconds = (min * 60) + secs
		totalStaticSeconds = totalSeconds
		startNewTimer = false
	}

	private func updateTimerWith(_ min: inout Int, _ secs: inout Int, isInBreak: Bool) {
		progress = CGFloat(totalSeconds) / CGFloat(totalStaticSeconds)
		progress = progress < 0 ? 0 : progress
		totalSeconds -= 1
		min = (totalSeconds / 60) % 60
		secs = totalSeconds % 60
		timerString = "\(min):\(secs < 10 ? "0" : "")\(secs)"

		guard isInBreak else { return }
 		guard min == 0 && secs == 0 else { return }

		isActive = false
		isBreakActive = false
		progress = 1
	}
}
