import SwiftUI


struct ContentView: View {

	@Environment(\.scenePhase) private var scenePhase

	@EnvironmentObject private var timerViewModel: TimerViewModel

	@State private var lastActiveTimestamp = Date()

	var body: some View {

		VStack {

			Text("Cathal")
				.font(.custom("Avenir Next", size: 20))
				.fontWeight(.semibold)
				.foregroundColor(.gray)
				.padding(topSafeArea - 10)

			GeometryReader { _ in

				VStack(spacing: 15) {
					ProgressView()
					Button("Start") {
						timerViewModel.startNewTimer = true
					}
					.neumorphicButton()
					.padding(.top, 20)
					.disabled(timerViewModel.isActive || timerViewModel.isBreakActive)
					.opacity(timerViewModel.isActive || timerViewModel.isBreakActive ? 0.5 : 1)
					.animation(.easeInOut(duration: 0.5), value: timerViewModel.isActive || timerViewModel.isBreakActive)

					Button("Stop") {
						timerViewModel.stopTimer()
					}
					.neumorphicButton()
					.disabled(!timerViewModel.isActive && !timerViewModel.isBreakActive)
					.opacity(!timerViewModel.isActive && !timerViewModel.isBreakActive ? 0.5 : 1)
					.animation(.easeInOut(duration: 0.5), value: !timerViewModel.isActive || !timerViewModel.isBreakActive)

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
						let deadline = timerViewModel.minutes == 0 && timerViewModel.breakMinutes == 0 ? 0.0 : 0.25
						DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
							timerViewModel.startNewTimer = false
						}
						timerViewModel.minutes = 0
						timerViewModel.breakMinutes = 0
					}

				NewTimerView()
					.frame(maxHeight: .infinity, alignment: .bottom)
					.offset(y: timerViewModel.startNewTimer ? 0 : 400)
			}
			.animation(.easeInOut, value: timerViewModel.startNewTimer)
		)
		.background(Color.neumorphicWhite)
		.ignoresSafeArea()
		.preferredColorScheme(.light)
		.onChange(of: scenePhase) { newPhase in
			guard timerViewModel.isActive || timerViewModel.isBreakActive else { return }
			switch newPhase {
				case .background: lastActiveTimestamp = Date()
				case .active:
					let elapsedTime = Int(Date().timeIntervalSince(lastActiveTimestamp))
					if timerViewModel.totalSeconds - elapsedTime <= 0 {
						timerViewModel.isActive = false
						timerViewModel.progress = 1
						timerViewModel.minutes = 0
						timerViewModel.seconds = 0
						timerViewModel.totalSeconds = 0
						timerViewModel.startBreakTimer()
					}
					else { timerViewModel.totalSeconds -= elapsedTime }
				default: break
			}
		}
		.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
			if timerViewModel.isActive { timerViewModel.updateTimer() }
			else if !timerViewModel.isActive && timerViewModel.isBreakActive {
				timerViewModel.updateBreakTimer()
			}
		}
	}

	@ViewBuilder
	private func NewTimerView() -> some View {
		let min = timerViewModel.breakMinutes > 1 ? "mins" : "min"
		VStack(spacing: 15) {
			Text("Start new Pomodoro session")
				.font(.system(size: 20))
				.foregroundColor(.gray)
				.padding(.top, 10)

			HStack {
				Group {
					Button("\(timerViewModel.minutes) min") {
						presentAlertVC(placeholder: "60m") { text in 
							timerViewModel.minutes = Int(text) ?? 0
						}
					}
					.id("minutes" + String(timerViewModel.minutes))
					Button("\(timerViewModel.breakMinutes) \(min) break") {
						presentAlertVC(placeholder: "20m") { text in
							timerViewModel.breakMinutes = Int(text) ?? 0
						}
					}
					.minimumScaleFactor(0.8)
					.id("breakMinutes" + String(timerViewModel.breakMinutes))
				}
				.neumorphicButton()
				.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
			}
			Button("Confirm") {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
					timerViewModel.startTimer()
				}
			}
			.font(.system(size: 18))
			.foregroundColor(.gray)
			.padding(.horizontal, 30)
			.neumorphicButton()
			.disabled(timerViewModel.minutes == 0 || timerViewModel.breakMinutes == 0)
			.opacity(timerViewModel.minutes == 0 || timerViewModel.breakMinutes == 0 ? 0.5 : 1)
			.animation(.easeInOut(duration: 0.5), value: timerViewModel.minutes > 0 && timerViewModel.breakMinutes > 0)

		}
		.padding()
		.frame(maxWidth: .infinity)
		.neumorphicStyle()
	}

	private func presentAlertVC(placeholder: String, primaryAction: @escaping(String) -> ()) {
		uiKitAlertVC(
			title: "Cathal",
			message: "Start a new pomodoro session with a regular & a break interval",
			placeholder: placeholder,
			primaryTitle: "Confirm",
			secondaryTitle: "Cancel",
			primaryAction: primaryAction
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
				.secondColor,
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
	func neumorphicButton() -> some View {
		self
			.buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 20, style: .continuous)))
	}
	func neumorphicStyle() -> some View {
		self
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.neumorphicWhite)
			.cornerRadius(20, corners: [.topLeft, .topRight])
			.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
			.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
	}
	func uiKitAlertVC(
		title: String,
		message: String,
		placeholder: String,
		primaryTitle: String,
		secondaryTitle: String,
		primaryAction: @escaping(String) -> ()) {

			let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alertVC.view.tintColor = UIColor(.firstColor)
			alertVC.overrideUserInterfaceStyle = .light
			alertVC.addTextField { textField in
				textField.placeholder = placeholder
				textField.keyboardType = .numberPad
			}
			alertVC.addAction(UIAlertAction(title: primaryTitle, style: .default) { _ in
				primaryAction(alertVC.textFields?.first?.text ?? "")
			})	
			alertVC.addAction(UIAlertAction(title: secondaryTitle, style: .default) { _ in })
			rootVC.present(alertVC, animated: true, completion: nil)

	}
	var rootVC: UIViewController {
		UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
	}
	var topSafeArea: CGFloat {
		UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
	}
}
