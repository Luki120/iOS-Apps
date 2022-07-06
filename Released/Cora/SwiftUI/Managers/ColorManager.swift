import SwiftUI
import UIKit


// Credits to: https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

extension Color: RawRepresentable {

	public init?(rawValue: String) {
		guard let data = Data(base64Encoded: rawValue) else {
			self = .black
			return
		}

		do {
			let unarchivedColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
			self = Color(unarchivedColor)
		}
		catch { self = .black }
	}

	public var rawValue: String {
		do {
			let archivedData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
			return archivedData.base64EncodedString()
		}
		catch { return "" }
	}

}
