import UIKit


// random color
// https://stackoverflow.com/questions/33882130/button-that-will-generate-a-random-background-color-xcode-swift

extension UIColor {
	static var randomColor: UIColor {
		let r = CGFloat.random(in: 0...1)
		let g = CGFloat.random(in: 0...1)
		let b = CGFloat.random(in: 0...1)

		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
}
