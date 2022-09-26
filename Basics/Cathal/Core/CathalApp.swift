import SwiftUI


@main
struct CathalApp: App {
	@StateObject private var timerViewModel = TimerViewModel()
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(timerViewModel)
		}
	}
}
