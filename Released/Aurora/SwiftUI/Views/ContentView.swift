import SwiftUI
import SafariServices


struct ContentView: View {

	@AppStorage("sliderValue") private var sliderValue = 0.0

	@Environment(\.colorScheme) private var colorScheme

	@State private var passwordText = ""
	@State private var shouldShowSafariSheet = false
	@State private var shouldShowSettingsSheet = false

	private let kSourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Released/Aurora"

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

					VStack(spacing: 5) {
 
						AttributedLabelView(string: passwordText)
							.frame(width: 248.5, height: 26.5)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
							.id("passwordText" + passwordText)

						Button("Regenerate password") {
							passwordText = randomString(length: Int(sliderValue))
						}
						.customButton()
						.padding(.top, 10)
						.onAppear {
							passwordText = randomString(length: Int(sliderValue))
						}

						Button("Copy password") { UIPasteboard.general.string = passwordText }
							.customButton()

						HStack {

							Slider(value: $sliderValue, in: 10...25, onEditingChanged: { _ in
								passwordText = randomString(length: Int(sliderValue))
							})
							.frame(width: UIScreen.main.bounds.width - 100, height: 44)

							Text("\(sliderValue, specifier: "%.0f")")
								.font(.system(size: 10))
								.foregroundColor(.gray)

						}

					}

					Spacer()

				}
				.toolbar {

					ToolbarItem(placement: .navigationBarTrailing) {

						HStack {

							Text("")

							Button { shouldShowSettingsSheet.toggle() }

							label: { Image(systemName: "gear") }
								.sheet(isPresented: $shouldShowSettingsSheet) { settingsView }

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
		.accentColor(Color.auroraColor)

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
					.toggleStyle(SwitchToggleStyle(tint: Color.auroraColor))
					.listRowBackground(colorScheme == .dark ? Color.black : Color.white)
				}
			}
			.padding(.top, 22)

			Section(footer: Text("")) {

				VStack {

					Button { shouldShowSafariSheet.toggle() }
						label: { Text("Source Code") }
							.font(.system(size: 15.5))
							.foregroundColor(.gray)
							.sheet(isPresented: $shouldShowSafariSheet) {
								SafariView(url: URL(string: kSourceCodeURL))
							}

					Text("2022 © Luki120")
						.font(.system(size: 10))
						.foregroundColor(.gray)
						.padding(.top, 5)

				}

			}
			.padding(.top, 10)

		}
		.background(colorScheme == .dark ? Color.black : Color.white)

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

}


private struct SafariView: UIViewControllerRepresentable {

	let url: URL?

	func makeUIViewController(context: Context) -> SFSafariViewController {
		let fallbackURL = URL(string: "https://github.com/Luki120")! // this 100% exists so it's safe
		guard let url = url else { return SFSafariViewController(url: fallbackURL) }
		return SFSafariViewController(url: url)
	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}

}


private struct AttributedLabelView: UIViewRepresentable {

	let string: String
	private let numbersAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
	private let symbolsAttribute = [NSAttributedString.Key.foregroundColor: UIColor.salmonColor]

	func makeUIView(context: Context) -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: 22)
		label.numberOfLines = 1
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		return label
	}

	func updateUIView(_ uiView: UILabel, context: Context) {
		uiView.attributedText = attributedString(
			string: string,
			numbersAttribute: numbersAttribute,
			symbolsAttribute: symbolsAttribute
		)
	}

	// MARK: Attributed String

	private func findRangesInString(_ string: String, withPattern pattern: String) -> [NSRange] {
		let nsString = string as NSString
		let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
		let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, nsString.length))
		return matches?.map { $0.range } ?? []
	}

	private func attributedString(
		string: String,
		numbersAttribute: [NSAttributedString.Key : Any],
		symbolsAttribute: [NSAttributedString.Key : Any]
	) -> NSAttributedString {

		let symbolRanges = findRangesInString(string, withPattern: "[!@#$%^&*()_+-=\\[\\\\\\]{}|;':,./<>?`~]+")
		let numberRanges = findRangesInString(string, withPattern: "[0-9]+")

		let attributedString = NSMutableAttributedString(string: string)

		for range in symbolRanges {
			attributedString.addAttributes(symbolsAttribute, range: range)
		}
		for range in numberRanges {
			attributedString.addAttributes(numbersAttribute, range: range)
		}
		return attributedString
	}

}
