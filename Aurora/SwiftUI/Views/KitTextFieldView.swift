import SwiftUI


struct KitTextFieldView: UIViewRepresentable {

	/*--- until I get an iOS 15 SDK with theos so I can use 
	the new @FocusState property wrapper, this'll have to do
	to make up for the shitty SwiftUI TextField component :uhhDistorted ---*/

	let tag: Int
	let placeholder: String
	let returnKeyType: UIReturnKeyType

	@Binding var text: String
	@Binding var shouldFocus: [Bool]

	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField(frame: .zero)
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

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, UITextFieldDelegate {

		var parent: KitTextFieldView

		init(_ textField: KitTextFieldView) {
			self.parent = textField
		}

		func textFieldDidChangeSelection(_ textField: UITextField) {
			// Without async this will modify the state during view update.
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
				// Without async this will modify the state during view update.
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
