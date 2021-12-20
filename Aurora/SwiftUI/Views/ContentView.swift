import SwiftUI
import SafariServices


struct ContentView: View {

	@AppStorage("sliderValue") private var sliderValue: Double = 0
	@AppStorage("uppercaseStrings") private var shouldAllowUppercaseStrings = false
	@AppStorage("lowercaseStrings") private var shouldAllowLowercaseStrings = false
	@AppStorage("numberCharacters") private var shouldAllowNumberCharacters = false
	@AppStorage("specialCharacters") private var shouldAllowSpecialCharacters = false
	@AppStorage("onlyUppercaseStrings") private var onlyUppercaseStrings = false
	@AppStorage("onlyNumberCharacters") private var onlyNumberCharacters = false
	@AppStorage("onlySpecialCharacters") private var onlySpecialCharacters = false

	@Environment(\.colorScheme) private var colorScheme

	@State private var passwordText = ""
	@State private var fadePasswordText = false
	@State private var shouldShowSafariSheet = false
	@State private var shouldShowSettingsSheet = false

	private let auroraColor = Color(red: 0.74, green: 0.78, blue: 0.98)
	private let sourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Aurora"

	init() {
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
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

		if shouldAllowUppercaseStrings { characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }

		if shouldAllowNumberCharacters { characters += "0123456789" }

		if shouldAllowSpecialCharacters { characters += "!¡@·#$~%&/()=?¿[]{}-,.;:_+*<>|" }

		if onlyUppercaseStrings { characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }

		if onlyNumberCharacters { characters = "0123456789" }

		if onlySpecialCharacters { characters = "!¡@·#$~%&/()=?¿[]{}-,.;:_+*<>|" }

		return String((0..<length).map { _ in characters.randomElement() ?? "c" })

	}

	private var settingsView: some View {

		VStack {

			Form {

				HStack { 

					Toggle("A-Z", isOn: $shouldAllowUppercaseStrings)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))
						
				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

				HStack {

					Toggle("0-9", isOn: $shouldAllowNumberCharacters)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))
					
				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

				HStack {

					Toggle("!@#$%^&*", isOn: $shouldAllowSpecialCharacters)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))

				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

				HStack {

					Toggle("Only uppercase", isOn: $onlyUppercaseStrings)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))

				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

				HStack {

					Toggle("Only numbers", isOn: $onlyNumberCharacters)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))

				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

				HStack {

					Toggle("Only special characters", isOn: $onlySpecialCharacters)
						.toggleStyle(SwitchToggleStyle(tint: auroraColor))

				}
				.listRowBackground(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

			}

			VStack {

				Button { shouldShowSafariSheet.toggle() }
					label: { Text("Source Code") }
						.font(.system(size: 15.5))
						.foregroundColor(.gray)
						.sheet(isPresented: $shouldShowSafariSheet) {
							if let url = URL(string: sourceCodeURL) {
								SafariView(url: url)
							}
						 }

				Text("2021 © Luki120")
					.font(.system(size: 10))
					.foregroundColor(.gray)
					.padding(.top, 5)

			}.padding(.bottom, 30)

		}
		.background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

	}

}


struct SafariView: UIViewControllerRepresentable {

	let url: URL

	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
		return SFSafariViewController(url: url)
	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

	}

}
