import SwiftUI


@main
struct CathalApp: App {
	@StateObject var timerViewModel = TimerViewModel()
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(timerViewModel)
		}
	}
}
