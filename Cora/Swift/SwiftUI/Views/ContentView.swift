import SwiftUI
import SafariServices


struct ContentView: View {

	@AppStorage("accentColor") private var pickerColor:Color = .green
	@AppStorage("switchState") private var shouldShowDarwinInformation = false

	@Environment(\.colorScheme) private var colorScheme

	@State private var darwinText = ""
	@State private var uptimeText = ""
	@State private var shouldShowSafariSheet = false
	@State private var shouldShowSettingsSheet = false

	@ObservedObject private var taskManager = TaskManager()

	private let sourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Cora"
	private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	init() {
		taskManager.launchDarwinTask()
		taskManager.launchUptimeTask()
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
	}

	var body: some View {

		NavigationView {

			VStack {

				Spacer()

				Text(uptimeText)
					.onAppear {

						guard let uptimeString = taskManager.uptimeString else {
							return
						}

						uptimeText = uptimeString

						animateUptimeLabel()

					}
					.onReceive(timer) { _ in

						taskManager.launchUptimeTask()
						uptimeText = taskManager.uptimeString ?? ""

					}
					.font(.custom("Courier", size: 16))
					.foregroundColor(pickerColor)
					.multilineTextAlignment(.center)
					.padding()

					.toolbar {

						ToolbarItem(placement: .navigationBarTrailing) {

							HStack {

								Button { shouldShowSettingsSheet.toggle() }
									label: { Image(systemName: "gear") }
										.font(.system(size: 10))

								Text("")
							}

						}

					}
					.sheet(isPresented: $shouldShowSettingsSheet) { settingsView }

				Spacer()

				Text(darwinText)
					.font(.custom("Courier", size: 12))
					.foregroundColor(pickerColor)
					.multilineTextAlignment(.center)
					.padding()
					.onAppear {

						darwinText = shouldShowDarwinInformation ? taskManager.darwinString ?? "" : ""

					}

			}

		}
		.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(pickerColor)

	}

	private var settingsView: some View {

		VStack {

			HStack {

				Toggle("Print Darwin Information", isOn: $shouldShowDarwinInformation)
					.font(.custom("Courier", size: 15.5))
					.foregroundColor(pickerColor)
					.padding(.horizontal)
					.toggleStyle(SwitchToggleStyle(tint: pickerColor))
					.onChange(of: shouldShowDarwinInformation) { newValue in

						if newValue { darwinText = taskManager.darwinString ?? "" }
						else { darwinText = "" }

					}

			}
			.padding(.horizontal)

			HStack {

				ColorPicker("Accent Color", selection: $pickerColor)
					.font(.custom("Courier", size: 15.5))
					.foregroundColor(pickerColor)
					.lineLimit(1)
					.minimumScaleFactor(0.5)
					.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 26.5))

			}
			.padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

			VStack {

				Button("Source Code") { shouldShowSafariSheet.toggle() }
					.font(.custom("Courier", size: 15.5))
					.opacity(0.5)
					.foregroundColor(pickerColor)
					.sheet(isPresented: $shouldShowSafariSheet) {

						if let url = URL(string: sourceCodeURL) {
							SafariView(url: url)
						}

					}

				Text("2021 © Luki120")
					.font(.custom("Courier", size: 10))
					.opacity(0.5)
					.foregroundColor(pickerColor)
					.padding(.top, 10)

			}
			.padding(.top, 50)

			Spacer()

		}
		.padding(.top, 44)
		.background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))

	}

	private func animateUptimeLabel() {

		uptimeText = ""
		let finalText = taskManager.uptimeString
		var charIndex = 0.0

		for letter in finalText ?? "" {
			Timer.scheduledTimer(withTimeInterval: 0.020 * charIndex, repeats: false) { (timer) in
				self.uptimeText.append(letter)
			}
			charIndex += 1
		}

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
