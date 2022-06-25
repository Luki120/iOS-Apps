import UIKit


// random color method
// https://stackoverflow.com/questions/33882130/button-that-will-generate-a-random-background-color-xcode-swift


func randomCGFloat() -> CGFloat {

	return CGFloat.random(in: 0...1)

}

extension UIColor {

	static func randomColor() -> UIColor {

		let r = randomCGFloat()
		let g = randomCGFloat()
		let b = randomCGFloat()

		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}

}
