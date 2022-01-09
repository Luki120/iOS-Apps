import SwiftUI
import SafariServices


struct ContentView: View {

	@AppStorage("sliderValue") private var sliderValue = 0.0

	@Environment(\.colorScheme) private var colorScheme

	@State private var passwordText = ""
	@State private var fadePasswordText = false
	@State private var shouldShowSafariSheet = false
	@State private var shouldShowSettingsSheet = false

	private let auroraColor = Color(red: 0.74, green: 0.78, blue: 0.98)
	private let sourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Aurora"

	init() {
 		UINavigationBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().clipsToBounds = true
		UITabBar.appearance().isTranslucent = false
		UITabBar.appearance().backgroundColor = .systemBackground
		UITabBar.appearance().layer.borderWidth = 0
		UITableView.appearance().backgroundColor = .clear
	}

	var body: some View {

		TabView {

			NavigationView {

				VStack {

 					if !fadePasswordText {

						Text(passwordText)
							.modifier(LabelStyle())
							.onAppear { self.passwordText = randomString(length: Int(sliderValue)) }

					}
 
					else if fadePasswordText {

						Text(passwordText)
							.modifier(LabelStyle())
							.onAppear { self.passwordText = randomString(length: Int(sliderValue)) }

					}

					Button("Regenerate password") {
						passwordText = randomString(length: Int(sliderValue))
						fadePasswordText.toggle()
					}
					.modifier(ButtonStyle())
					.padding(.top, 2.5)

					Button("Copy password") { UIPasteboard.general.string = passwordText }
						.modifier(ButtonStyle())
						.padding(.top, -2.5)

					HStack {

						Slider(value: $sliderValue, in: 0...25, onEditingChanged: { _ in

							passwordText = randomString(length: Int(sliderValue))

						})
						.frame(width: UIScreen.main.bounds.width - 100, height: 44)

						Text("\(sliderValue, specifier: "%.0f")")
							.font(.system(size: 10))
							.foregroundColor(Color(.gray))

					}
					.padding(.top, -2.5)

					Spacer()

				}
				.toolbar {
					
					ToolbarItem(placement: .navigationBarTrailing) {

						HStack {

							Button { shouldShowSettingsSheet.toggle() }

							label: { Image(systemName: "gear") }
								.sheet(isPresented: $shouldShowSettingsSheet) { settingsView }

							Text("")

						}

					}

				}
				.navigationBarTitle("Aurora", displayMode: .inline)
				.padding(20)

			}
			.navigationViewStyle(StackNavigationViewStyle())
			.tabItem {

				Image(systemName: "house.fill")
					.font(.system(size: 22))

			}

			VaultView()

		}
		.accentColor(auroraColor)

	}

	private func randomString(length: Int) -> String {

 		var characters = "abcdefghijklmnopqrstuvwxyz"

		let numbers = "0123456789"
		let specialCharacters = "!@#$%^&*()_+-=[]{}|;':,./<>?`~"
		let uppercaseCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

		if allowUppercaseCharacters { characters += uppercaseCharacters }

		if allowNumberCharacters { characters += numbers }

		if allowSpecialCharacters { characters += specialCharacters }

		else if !allowUppercaseCharacters && !allowNumberCharacters && !allowSpecialCharacters {

			characters = "abcdefghijklmnopqrstuvwxyz"

		}

		return String((0..<length).map { _ in characters.randomElement() ?? "c" })

	}

	@AppStorage("allowNumberCharacters") private var allowNumberCharacters = false
	@AppStorage("allowSpecialCharacters") private var allowSpecialCharacters = false
 	@AppStorage("allowUppercaseCharacters") private var allowUppercaseCharacters = false

	private var settingsView: some View {

		VStack {

			Form {

				Section(header: Text("Settings")) {

					Group {

						Toggle("A-Z", isOn: $allowUppercaseCharacters)
						Toggle("0-9", isOn: $allowNumberCharacters)
						Toggle("!@#$%^&*", isOn: $allowSpecialCharacters)

					}
					.toggleStyle(SwitchToggleStyle(tint: auroraColor))
					.listRowBackground(colorScheme == .dark ? Color.black : Color.white)

				}

			}
			.padding(.top, 22)

			Section(footer:

				VStack {

					Button { shouldShowSafariSheet.toggle() }
						label: { Text("Source Code") }
							.font(.system(size: 15.5))
							.foregroundColor(.gray)
							.sheet(isPresented: $shouldShowSafariSheet) {
								getURLFromURLString(string: sourceCodeURL)
							}

					Text("2021 © Luki120")
						.font(.system(size: 10))
						.foregroundColor(.gray)
						.padding(.top, 5)

				}
				.padding(.bottom, 30)

			) {}

		}
		.background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

	}

	private func getURLFromURLString(string: String) -> AnyView {

		guard let url = URL(string: string) else {
			return AnyView(Text("Invalid URL"))
		}

		return AnyView(SafariView(url: url))

	}

}


private struct SafariView: UIViewControllerRepresentable {

	let url: URL

	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
		return SFSafariViewController(url: url)
	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

	}

}
