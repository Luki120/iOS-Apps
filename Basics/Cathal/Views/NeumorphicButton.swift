import SwiftUI


struct Background<S: Shape>: View {
	var isPressed: Bool
	var shape: S

	var body: some View {
		ZStack {
			if isPressed {
				shape
					.fill(Color.neumorphicWhite)
					.overlay(
						shape
							.stroke(Color.gray, lineWidth: 3)
							.blur(radius: 4)
							.offset(x: 2, y: 2)
							.mask(shape.fill(LinearGradient(Color.black, Color.clear)))
					)
					.overlay(
						shape
							.stroke(Color.white, lineWidth: 3)
							.blur(radius: 4)
							.offset(x: -2, y: -2)
							.mask(shape.fill(LinearGradient(Color.clear, Color.black)))
					)
			}
			else {
				shape
					.fill(Color.neumorphicWhite)
					.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
					.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
			}
		}
	}
}


struct NeumorphicButton<S: Shape>: ButtonStyle {
	var shape: S

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(15)
			.frame(width: 120, height: 40)
			.foregroundColor(.gray)
			.background(Background(isPressed: configuration.isPressed, shape: shape))
	}
}
