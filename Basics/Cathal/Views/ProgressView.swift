import SwiftUI


struct ProgressView: View {

	@EnvironmentObject var timerViewModel: TimerViewModel

	var body: some View {

		ZStack {

			Circle()
				.stroke(LinearGradient.cathalGradient, lineWidth: 20)
				.frame(width: 150, height: 150)
				.opacity(0.5)

			Circle()
				.trim(from: 0, to: timerViewModel.progress)
				.stroke(
					LinearGradient.cathalGradient,
					style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
				)
				.shadow(color: Color.secondColor, radius: 5, x: 1, y: -4)
				.frame(width: 150, height: 150)
				.rotationEffect(.degrees(270))
				.animation(.linear)

			FadeLabelView(text: timerViewModel.timerString)
				.frame(width: 80, height: 80)

		}

	}

}


private struct FadeLabelView: UIViewRepresentable {
	var text: String
	func makeUIView(context: Context) -> UILabel {
		let label = UILabel()
		label.font = UIFont(name: "Avenir-Black", size: 35)
		label.textColor = .gray
		label.textAlignment = .center
		return label
	}
	func updateUIView(_ uiView: UILabel, context: Context) {
		let transition = CATransition()
		transition.duration = 0.5
		transition.type = CATransitionType.fade
		transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		uiView.layer.add(transition, forKey: nil)

		uiView.text = text
	}
}
