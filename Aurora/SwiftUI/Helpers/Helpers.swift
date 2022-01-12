import SwiftUI


struct ButtonStyle: ViewModifier {

	func body(content: Content) -> some View {

		content
			.font(.system(size: 18))
			.frame(width: 220, height: 44)
			.background(Color.auroraColor)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

	}

}


struct LabelStyle: ViewModifier {

	func body(content: Content) -> some View {

		content
			.font(.system(size: 22))
			.lineLimit(1)
			.minimumScaleFactor(0.5)
			.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))

	}

}


extension Color {

	static let auroraColor = Color(red: 0.74, green: 0.78, blue: 0.98)

}
