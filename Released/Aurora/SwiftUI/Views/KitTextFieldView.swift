import SwiftUI


struct KitTextFieldView: UIViewRepresentable {

	// iOS 14 wacky support for the lack of a responder chain
	// type solution for moving through text fields in SwiftUI

	let tag: Int
	let placeholder: String
	let returnKeyType: UIReturnKeyType

	@Binding var text: String
	@Binding var shouldFocus: [Bool]

	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.tag = tag
		textField.delegate = context.coordinator
		textField.placeholder = placeholder
		textField.returnKeyType = returnKeyType

		if textField.textContentType == .password || textField.textContentType == .newPassword {
			textField.isSecureTextEntry = true
		}

		return textField
	}

	func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = text
		if uiView.window != nil {
			if shouldFocus[tag] {
				if !uiView.isFirstResponder { uiView.becomeFirstResponder() }
			}
			else { uiView.resignFirstResponder() }
		}
	}

	func makeCoordinator() -> Coordinator { Coordinator(self) }

	final class Coordinator: NSObject, UITextFieldDelegate {

		var parent: KitTextFieldView

		init(_ parent: KitTextFieldView) {
			self.parent = parent
		}

		func textFieldDidChangeSelection(_ textField: UITextField) {
			DispatchQueue.main.async {
				self.parent.text = textField.text ?? ""
			}
		}

		func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
			setFocus(tag: parent.tag)
			return true
		}

		func setFocus(tag: Int) {
			let reset = tag >= parent.shouldFocus.count || tag < 0

			if reset || !parent.shouldFocus[tag] {
				var newFocus = [Bool](repeatElement(false, count: parent.shouldFocus.count))
				if !reset { newFocus[tag] = true }
				DispatchQueue.main.async {
					self.parent.shouldFocus = newFocus
				}
			}
		}

		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			setFocus(tag: parent.tag + 1)
			return true
		}
	}
}
