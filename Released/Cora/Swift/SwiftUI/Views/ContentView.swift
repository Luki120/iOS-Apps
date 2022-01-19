import SwiftUI
import SafariServices


struct ContentView: View {

	@AppStorage("accentColor") private var pickerColor:Color = .green

	@Environment(\.colorScheme) private var colorScheme

	@State private var darwinText = ""
	@State private var uptimeText = ""
	@State private var shouldShowSafariSheet = false
	@State private var shouldShowSettingsSheet = false

	@StateObject private var taskManager = TaskManager()

	private let sourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Cora"
	private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	init() {
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
	}

	var body: some View {

		NavigationView {

			VStack {

				Spacer()

				Text(uptimeText)
					.font(.custom("Courier", size: 16))
					.foregroundColor(pickerColor)
					.multilineTextAlignment(.center)
					.padding()
					.onAppear {
						setUptimeText()
						animateUptimeLabel()
					}
					.onReceive(timer) { _ in
 						taskManager.launchTask(withArguments: ["-c", "uptime"])
						uptimeText = taskManager.outputString ?? ""
					}
					.toolbar {

						ToolbarItem(placement: .navigationBarTrailing) {

							HStack {

								Text("")

								Button { shouldShowSettingsSheet.toggle() }
									label: { Image(systemName: "gear") }
										.font(.system(size: 10))

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
					.onAppear(perform: setDarwinText)

			}

		}
		.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(pickerColor)

	}

	private var settingsView: some View {

		VStack {

			Toggle("Print Darwin Information", isOn: taskManager.$shouldPrintDarwinInformation)
				.font(.custom("Courier", size: 15))
				.padding(.horizontal)
				.foregroundColor(pickerColor)
				.toggleStyle(SwitchToggleStyle(tint: pickerColor))
				.onChange(of: taskManager.shouldPrintDarwinInformation) { newValue in
					if newValue { setDarwinText() }
					else { darwinText = "" }
				}

			ColorPicker("Accent Color", selection: $pickerColor)
				.font(.custom("Courier", size: 15))
				.foregroundColor(pickerColor)
				.padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 26.5))

			Spacer()

			Section(footer: Text("")) {

				VStack {

					Button("Source Code") { shouldShowSafariSheet.toggle() }
						.font(.custom("Courier", size: 15.5))
						.opacity(0.5)
						.foregroundColor(pickerColor)
						.sheet(isPresented: $shouldShowSafariSheet) {
							SafariView(url: URL(string: sourceCodeURL))
						}

					Text("2022 © Luki120")
						.font(.custom("Courier", size: 10))
						.opacity(0.5)
						.foregroundColor(pickerColor)
						.padding(.top, 10)

				}

			}
			.padding(.top, 10)

		}
		.padding(.top, 44)
		.background(colorScheme == .dark ? Color.black : Color.white)

	}

	private func setUptimeText() {

		taskManager.launchTask(withArguments: ["-c", "uptime"])

		guard let uptimeString = taskManager.outputString else {
			return
		}

		uptimeText = uptimeString

	}

	private func setDarwinText() {

		guard taskManager.shouldPrintDarwinInformation else { return }

		taskManager.launchTask(withArguments: ["-c", "uname -a"])

		guard let darwinString = taskManager.outputString else {
			return
		}			

		darwinText = darwinString

	}

	private func animateUptimeLabel() {

		uptimeText = ""
		let finalText = taskManager.outputString ?? ""
		var charIndex = 0.0

		for letter in finalText {
			Timer.scheduledTimer(withTimeInterval: 0.020 * charIndex, repeats: false) { timer in
				self.uptimeText.append(letter)
			}
			charIndex += 1
		}

	}

}


private struct SafariView: UIViewControllerRepresentable {

	let url: URL?

	func makeUIViewController(context: Context) -> SFSafariViewController {

		let fallbackURL = URL(string: "https://github.com/Luki120")! // this 100% exists so it's safe

		guard let url = url else {
			return SFSafariViewController(url: fallbackURL)
		}

		return SFSafariViewController(url: url)

	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

	}

}
