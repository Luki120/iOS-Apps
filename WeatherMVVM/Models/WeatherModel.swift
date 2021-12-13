import SwiftUI


struct WeatherModel: Codable {

	let name: String
	let main: Main
	let weather: [Weather]

}


struct Main: Codable {

	let temp: Float

}


struct Weather: Codable {

	let description: String

}
