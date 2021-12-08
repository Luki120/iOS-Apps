import SwiftUI
import SafariServices


struct ContentView: View {

	@State private var darwinText = ""
	@State private var uptimeText = ""
	@State private var showSafari = false
	@State private var sourceCodeURL = "https://github.com/Luki120/iOS-Apps/tree/main/Cora"
	@State private var sheetIsPresented = false

	@AppStorage("accentColor") private var pickerColor:Color = .green
	@AppStorage("switchState") private var shouldShowDarwinInformation = false

	@Environment(\.colorScheme) var colorScheme

	@ObservedObject private var taskManager = TaskManager()

	private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	init() {
		taskManager.launchDarwinTask()
		taskManager.launchUptimeTask()
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

								Button { sheetIsPresented.toggle() }
									label: { Image(systemName: "gear") }
										.font(.system(size: 10))

								Text("")
							}

						}

					}.sheet(isPresented: $sheetIsPresented) { settingsView }

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

		}.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(pickerColor)

	}

	private var settingsView: some View {

		VStack {

			HStack {

				Text("Print Darwin Information")
					.font(.custom("Courier", size: 15.5))
					.foregroundColor(pickerColor)
					.padding(.horizontal)

					Toggle("", isOn: $shouldShowDarwinInformation)
						.padding(.horizontal)
						.toggleStyle(SwitchToggleStyle(tint: pickerColor))
						.onChange(of: shouldShowDarwinInformation) { newValue in

							if newValue {
								darwinText = taskManager.darwinString ?? ""
							} 

							else {
								darwinText = ""
							}

						}

			}.padding(.horizontal)

			HStack {

				Text("Accent Color")
					.font(.custom("Courier", size: 15.5))
					.foregroundColor(pickerColor)
					.lineLimit(1)
					.minimumScaleFactor(0.5)
					.padding(.horizontal)

				Spacer()

				ColorPicker("", selection: $pickerColor)
				.padding(.trailing, 25)

			}.padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

			VStack {

				Button("Source Code") { showSafari.toggle() }
					.font(.custom("Courier", size: 15.5))
					.opacity(0.5)
					.foregroundColor(pickerColor)
					.sheet(isPresented: $showSafari) {

						if let url = URL(string: sourceCodeURL) {
							SafariView(url: url)
						}

					}

				Text("2021 © Luki120")
					.font(.custom("Courier", size: 10))
					.opacity(0.5)
					.foregroundColor(pickerColor)
					.padding(.top, 10)

			}.padding(.top, 50)

			Spacer()

		}
		.padding(.top, 44)
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
