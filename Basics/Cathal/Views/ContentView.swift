import SwiftUI


struct ContentView: View {

	@Environment(\.scenePhase) private var scenePhase

	@EnvironmentObject var timerViewModel: TimerViewModel

	@State private var lastActiveTimestamp = Date()

	var body: some View {

		VStack {

			Text("Cathal")
				.font(.custom("Avenir Next", size: 20))
				.fontWeight(.semibold)
				.foregroundColor(.gray)
				.padding(20)

			GeometryReader { _ in

				VStack(spacing: 15) {
					ProgressView()
					Button("Start") {
						timerViewModel.startNewTimer = true
					}
					.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20, style: .continuous)))
					.padding(.top, 20)
					.disabled(timerViewModel.isActive == true || timerViewModel.shouldStartBreak == true)
					.opacity(timerViewModel.isActive == true || timerViewModel.shouldStartBreak == true ? 0.5 : 1)

					Button("Stop") {
						timerViewModel.stopTimer()
					}
					.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20, style: .continuous)))
					.disabled(timerViewModel.isActive == false && timerViewModel.shouldStartBreak == false)
					.opacity(timerViewModel.isActive == false && timerViewModel.shouldStartBreak == false ? 0.5 : 1)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			}
			.padding(.top, -20)
		}
		.padding()
		.overlay(
			ZStack {
				Color.black
					.opacity(timerViewModel.startNewTimer ? 0.25 : 0.0)
					.onTapGesture {
						timerViewModel.minutes = 0
						timerViewModel.breakMinutes = 0
						timerViewModel.startNewTimer = false
					}

				newTimerView()
					.frame(maxHeight: .infinity, alignment: .bottom)
					.offset(y: timerViewModel.startNewTimer ? 0 : 400)
			}
			.animation(.easeInOut, value: timerViewModel.startNewTimer)
		)
		.background(Color.neumorphicWhite)
		.edgesIgnoringSafeArea(.all)
		.preferredColorScheme(.light)
		.onChange(of: scenePhase) { newPhase in
			if timerViewModel.isActive {
				if newPhase == .background {
					lastActiveTimestamp = Date()
				}
				else if newPhase == .active {
					let elapsedTime = Int(Date().timeIntervalSince(lastActiveTimestamp))
					if timerViewModel.totalSeconds - Int(elapsedTime) <= 0 {
						timerViewModel.isActive = false
						timerViewModel.isFinished = true
						timerViewModel.totalSeconds = 0
					}
					else { timerViewModel.totalSeconds -= elapsedTime }
				}
			}
		}
		.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
			if timerViewModel.isActive {
				timerViewModel.updateTimer()
			}
			else if !timerViewModel.isActive && timerViewModel.shouldStartBreak {
				timerViewModel.updateTimerWith(
					&timerViewModel.breakMinutes,
					&timerViewModel.breakSeconds,
					isInBreak: true
				)
			}
		}
	}

	@ViewBuilder
	private func newTimerView() -> some View {
		VStack(spacing: 15) {
			Text("Start new Pomodoro session")
				.font(.system(size: 20))
				.foregroundColor(.gray)
				.padding(.top, 10)

			HStack {
				Text("\(timerViewModel.minutes) min")
					.reusableLabel()
 					.contextMenu {
						contextMenuOptionsFor(timerViewModel.sessionIntervals) { value in
							timerViewModel.minutes = value
						}
					}
				Text("\(timerViewModel.breakMinutes) break min")
					.reusableLabel()
 					.contextMenu {
						contextMenuOptionsFor(timerViewModel.breakIntervals) { value in
							timerViewModel.breakMinutes = value
						}
					}

			}
			Button("Confirm") {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
					timerViewModel.startTimer()
				}
			}
			.font(.system(size: 18))
			.foregroundColor(.gray)
			.padding(.horizontal, 30)
			.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20, style: .continuous)))
			.disabled(timerViewModel.minutes == 0 || timerViewModel.breakMinutes == 0)
			.opacity(timerViewModel.minutes == 0 || timerViewModel.breakMinutes == 0 ? 0.5 : 1)

		}
		.padding()
		.frame(maxWidth: .infinity)
		.neumorphicStyle()
	}

	@ViewBuilder
	private func contextMenuOptionsFor(_ session: [String], onClick: @escaping (Int) -> ()) -> some View {
		ForEach(session, id: \.self) { value in
			Button("\(value) min") {
				onClick(Int(value) ?? 0)
			}
		}
	}
}


private struct ReusableLabel: ViewModifier {

	func body(content: Content) -> some View {
		content
			.font(.system(size: 18))
			.foregroundColor(.gray)
			.padding(.horizontal, 20)
			.padding(.vertical, 10)
			.background(
				Capsule(style: .continuous)
					.fill(Color.neumorphicWhite)
					.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
					.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
			)

	}

}


private struct RoundedCorner: Shape {

	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
    }
}


extension Color {
	static let firstColor = Color(red: 0.01, green: 0.67, blue: 0.69)
	static let secondColor = Color(red: 0.00, green: 0.80, blue: 0.67)
	static let neumorphicWhite = Color(red: 0.88, green: 0.88, blue: 0.92)
}


extension LinearGradient {
	static let cathalGradient = LinearGradient(
		gradient: Gradient(
			colors: [
				Color.secondColor,
				Color.secondColor
					.opacity(0.5),
				Color.secondColor
					.opacity(0.3),
				Color.secondColor
					.opacity(0.1)
			]
		),
		startPoint: .topLeading, endPoint: .bottomTrailing
	)
	init(_ colors: Color...) {
		self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
}


private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
    }
	func neumorphicStyle() -> some View {
		self.padding()
		.frame(maxWidth: .infinity)
		.background(Color.neumorphicWhite)
		.cornerRadius(20, corners: [.topLeft, .topRight])
		.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
		.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
	}
	func reusableLabel() -> some View { modifier(ReusableLabel()) }
}
