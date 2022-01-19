import SwiftUI


struct ContentView: View {

	/*--- even though the app is based on showing how
	NSNotificationCenter works, I made a SwiftUI version
	because first I didn't know theos supported it and also
	because these property wrappers take care of all the work :TimPog ---*/

	@AppStorage("counterCount") private var counter = 0

	@State private var labelAlpha = 0.0
	@State private var randomColor:Color = .randomColor

	private let firstColor = Color(red: 0.74, green: 0.78, blue: 0.98)
	private let secondColor = Color(red: 0.77, green: 0.69, blue: 0.91)
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	init() {
		UITabBar.appearance().barTintColor = .systemBackground
		UITabBar.appearance().isTranslucent = false
	}

	var body: some View {

		TabView {

			VStack {

				Button("Tap me and switch tabs to see magic") {
					counter += 1
					randomColor = .randomColor
				}
				.font(.system(size: 14))
				.frame(width: 260, height: 40)
				.buttonStyle(StaticButtonStyle())
				.background(
					LinearGradient(gradient: Gradient(
							colors: [firstColor, secondColor]
						),
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
				.foregroundColor(.white)
				.clipShape(Capsule(style: .continuous))
				.multilineTextAlignment(.center)

			}
			.tabItem {
				Image(systemName: "bolt.horizontal.fill")
				Text("Home")
			}

			NavigationView {

				VStack {

					Text(String(counter))
						.frame(width: 150, height: 40)
						.background(Color.randomColor)
						.foregroundColor(.white)
						.clipShape(Capsule(style: .continuous))

					Text("The power of SwiftUI 😈, learn it, embrace it, and use it to make awesome stuff")
						.font(.system(size: 16))
						.opacity(labelAlpha)
						.padding(.top, 15)
						.foregroundColor(Color(.systemPurple))
						.multilineTextAlignment(.center)

				}
				.onReceive(timer) { _ in fireTimer() }
				.toolbar {

					ToolbarItem(placement: .navigationBarTrailing) {

						Button { counter = 0 }
							label: { Image(systemName: "xmark.circle.fill") }

					}

				}

			}
			.navigationViewStyle(StackNavigationViewStyle())	
			.tabItem {
				Image(systemName: "bonjour")
				Text("Not Home")
			}

		}
		.accentColor(Color(.systemPurple))

	}

	private func fireTimer() {

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
}


private struct StaticButtonStyle: ButtonStyle {

	func makeBody(configuration: Configuration) -> some View {

		configuration.label

	}

}


private extension Color {

	static var randomColor: Color {

		let red = Double.random(in: 0...1)
		let green = Double.random(in: 0...1)
		let blue = Double.random(in: 0...1)

		return Color(red: red, green: green, blue: blue)

	}

}
