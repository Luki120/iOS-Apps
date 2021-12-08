import SwiftUI


struct ContentView: View {

	/*--- even though the app is based on showing how
	NSNotificationCenter works, I made a SwiftUI version
	because first I didn't know theos supported it and also
	because these property wrappers take care of all the work :TimPog ---*/

	@State private var color:Color = .randomColor
	@State private var labelAlpha = 0.0

	@AppStorage("counterCount") private var counter = 0

	private let firstColor = Color(red: 0.74, green: 0.78, blue: 0.98)
	private let secondColor = Color(red: 0.77, green: 0.69, blue: 0.91)

	init() {
		UITabBar.appearance().barTintColor = .systemBackground
		UITabBar.appearance().isTranslucent = false
	}

	var body: some View {

 		TabView {

			Button("Tap me and switch tabs to see the magic") {
				counter += 1
				color = .randomColor

				if counter == 14 {
					withAnimation(.easeInOut(duration: 0.5), {
						self.labelAlpha = 1
					})
				}

				else if counter == 15 {
					withAnimation(.easeInOut(duration: 0.5), {
						self.labelAlpha = 0
					})
				}
			}
				.font(.system(size :14))
				.frame(width: 260, height: 40)
				.buttonStyle(StaticButtonStyle())
				.background(Color(.systemIndigo))
				.foregroundColor(.white)
				.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
				.multilineTextAlignment(.center)

				.tabItem {
					Image(systemName: "bolt.horizontal.fill")
					Text("Home")
				}

			VStack {

				Spacer()

				Button(String(counter)) {}
					.frame(width: 150, height: 40)
					.background(color)
					.foregroundColor(.white)
					.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

				Button("Reset counter") { counter = 0 }
					.frame(width: 150, height: 40)
					.background(LinearGradient(
						gradient: 
						Gradient(colors: [firstColor, secondColor]),
						startPoint: .leading, 
						endPoint: .trailing)
					)
					.foregroundColor(.white)
					.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
					.padding(.top, 10)

				Spacer()

				Text("The power of Notifications :fr: Learn them, embrace them, and use them to make awesome stuff")
					.font(.system(size: 18))
					.opacity(labelAlpha)
					.padding(.all, 20)
					.lineLimit(nil)
					.foregroundColor(Color(.systemPurple))
					.multilineTextAlignment(.center)

			}
			.tabItem {
				Image(systemName: "bonjour")
				Text("Not Home")
			}
		}.accentColor(Color(.systemPurple))
	}
}

struct StaticButtonStyle: ButtonStyle {

	func makeBody(configuration: Configuration) -> some View {

		configuration.label

	}

}

extension Color {

	static var randomColor: Color {

		let red = Double.random(in: 0...1)
		let green = Double.random(in: 0...1)
		let blue = Double.random(in: 0...1)

		return Color(red: red, green: green, blue: blue)

	}

}
