import SwiftUI


struct ProgressView: View {

	var counter: Int
	var countTo: Int

	var body: some View {

		ZStack {

			Circle()
				.stroke(gradient, lineWidth: 20)
				.frame(width: 150, height: 150)
				.opacity(0.5)

			Circle()
				.trim(from: 0, to: progress())
				.stroke(gradient, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
				.frame(width: 150, height: 150)
				.rotationEffect(.degrees(270))
				.animation(.linear)

			VStack {

				Text(counterToMinutes())
					.font(.custom("Avenir Next", size: 35))
					.fontWeight(.black)
					.padding(10)
					.minimumScaleFactor(0.5)

			}

		}

	}

	private func counterToMinutes() -> String {

		let currentTime = countTo - counter
		let minutes = Int(currentTime / 60)
		let seconds = currentTime % 60

		return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"

	}

	private func progress() -> CGFloat { return CGFloat(counter) / CGFloat(countTo) }

}
