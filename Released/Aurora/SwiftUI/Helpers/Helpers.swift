import SwiftUI


struct CustomButton: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 18))
			.frame(width: 220, height: 44)
			.background(Color.auroraColor)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
	}
}


extension Color {
	static let auroraColor = Color(red: 0.74, green: 0.78, blue: 0.98)
}


extension UIColor {
	static let salmonColor = UIColor(red: 1.0, green: 0.55, blue: 0.51, alpha: 1.0)
}


extension View {
	func customButton() -> some View {
		modifier(CustomButton())
	}
}
