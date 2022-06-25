import SwiftUI


let gradient = LinearGradient(
	gradient: Gradient(
		colors: [Color.firstColor, Color.secondColor]
	),
	startPoint: .topLeading,
	endPoint: .bottomTrailing
)


struct ContentView: View {

	@State private var counter = 0
	@State private var countTo = 3600
	@State private var finishedBreak = false
	@State private var isActive = true
	@State private var isTimerRunning = false
	@State private var pomodoroCount = 0
	@State private var shouldShowToast = false
	@State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	@Environment(\.scenePhase) private var scenePhase

	private let kSourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Basics/Cathal"

	var body: some View {

		VStack {

			ProgressView(counter: counter, countTo: countTo)

			Button("Start") {
				guard !isTimerRunning else { return }

				isTimerRunning = true
				pomodoroCount += 1
				self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
				UIApplication.shared.isIdleTimerDisabled = true
			}
			.customButton()
			.padding(.top, 20)

		}
		.padding(.top, 50)
		.onReceive(timer) { _ in

			guard isActive else { return }

			if isTimerRunning && counter < countTo { counter += 1 }
			else if counter == countTo && !finishedBreak {
				counter = 0
				counter += 1
				countTo = 1200
				DispatchQueue.main.async {
					withAnimation(.easeInOut(duration: 1.0)) {
						shouldShowToast.toggle()
					}
				}
				finishedBreak = true
			}
			else if finishedBreak {
				counter = 0
				countTo = 3600
				finishedBreak = false
				isTimerRunning = false
				UIApplication.shared.isIdleTimerDisabled = false
			}

		}
 		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active { isActive = true }
			else { isActive = false }
		}

		Button("Pause") {
			isTimerRunning = false
			self.timer.upstream.connect().cancel()
		}
		.customButton()
		.padding(.top, 0.5)

		Spacer()

		VStack {

			if shouldShowToast && finishedBreak {
				Text("Good job! You completed \(pomodoroCount) pomodoros! Starting break now.")
					.font(.system(size: 18))
					.frame(width: 300, height: 40)
					.background(gradient)
					.transition(AnyTransition.opacity.combined(with: .scale))
					.clipShape(Capsule(style: .continuous))
					.minimumScaleFactor(0.5)
					.padding()
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
							withAnimation(.easeInOut(duration: 0.5)) {
								shouldShowToast.toggle()
							}
						}
					}

			}
			Button("Source Code") {
				UIApplication.shared.open(URL(string: kSourceCodeURL)!)
			}
			.font(.custom("American Typewriter", size: 15.5))
			.foregroundColor(.gray)
			
			Text("2022 © Luki120")
				.font(.custom("American Typewriter", size: 12))
				.foregroundColor(.gray)
				.padding(.top, 5)

		}
		.padding(.bottom, 20)

	}

}


private struct CustomButton: ViewModifier {

	func body(content: Content) -> some View {
		content
			.font(.system(size: 14))
			.frame(width: 120, height: 40)
			.background(gradient)
			.foregroundColor(.white)
			.cornerRadius(20, corners: [.topLeft, .bottomRight])
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


private extension View {
	func customButton() -> some View {
		modifier(CustomButton())
	}
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


extension Color {
	static let firstColor = Color(red: 0.01, green: 0.67, blue: 0.69)
	static let secondColor = Color(red: 0.00, green: 0.80, blue: 0.67)
}
