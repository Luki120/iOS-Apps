import SwiftUI


class WeatherViewModel: ObservableObject {

	@Published var name: String = ""
	@Published var temp: String = ""
	@Published var error: String = ""
	@Published var description: String = ""

	init() { fetchWeather() }

	func fetchWeather() {

		let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=40.78&lon=-73.9840&appid=32ccbffca96e33cf8541740016b493b6"

		guard let url = URL(string: apiURL) else {
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, _, error in

			if let data = data, error == nil {

				do {

					let weather = try JSONDecoder().decode(WeatherModel.self, from: data)

					DispatchQueue.main.async {

						self.description = weather.weather.first?.description ?? ""
						self.name = weather.name
						self.temp = String(format: "%.0f", weather.main.temp - 273.15)

					}

				}

				catch {

					DispatchQueue.main.async {

						self.error = error.localizedDescription
						return

					}

				}

			}

		}

		task.resume()

	}

}
