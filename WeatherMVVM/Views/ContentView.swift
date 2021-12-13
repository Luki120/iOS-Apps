import SwiftUI


struct ContentView: View {

	@ObservedObject var viewModel = WeatherViewModel()

	var body: some View {

		VStack {

			Text(viewModel.name)
				.font(.system(size: 30))

			Text(viewModel.description)
				.font(.system(size: 18))

			Text(viewModel.temp + "°")
				.font(.system(size: 90))

			Text(viewModel.error)
				.font(.system(size: 18))
				.multilineTextAlignment(.center)

		}.padding()

	}

}
