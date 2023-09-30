import SwiftUI


struct AddVaultItemView: View {

	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode

	@State private var name = ""
	@State private var username = ""
	@State private var password = ""

	@State private var focused = [true, false, false, false]

	@StateObject private var viewModel = VaultItemsViewModel.sharedInstance

	init() { UITableView.appearance().backgroundColor = .clear }

	var body: some View {

		NavigationView {
			ZStack {
				Color(colorScheme == .dark ? .black : .white)
				Form {
					Group {
						if #available(iOS 15.0, *) {
							FocusStateView(name: $name, username: $username, password: $password)
						}
						else {
							KitTextField(withTag: 0, placeholder: "Name", returnKeyType: .next, text: $name)
							KitTextField(withTag: 1, placeholder: "Username", returnKeyType: .next, text: $username)
							KitTextField(withTag: 2, placeholder: "Password", returnKeyType: .done, text: $password)
						}
 					}
					.listRowBackground(colorScheme == .dark ? Color.black : Color.white)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Create") {
							let vaultItem = VaultItems()
							vaultItem.name = name
							vaultItem.username = username
							vaultItem.password = password
							viewModel.feedArray(vaultItem: vaultItem)
							presentationMode.wrappedValue.dismiss()
						}
						.disabled(name.isEmpty || username.isEmpty || password.isEmpty)
					}
				}
			}
			.ignoresSafeArea()
			.navigationBarTitle("Add new item", displayMode: .inline)
		}
		.accentColor(.auroraColor)

	}

	@ViewBuilder
	private func KitTextField(
		withTag tag: Int,
		placeholder: String,
		returnKeyType: UIReturnKeyType,
		text: Binding<String>
	) -> some View {
  		KitTextFieldView(
			tag: tag,
			placeholder: placeholder,
			returnKeyType: returnKeyType,
			text: text,
			shouldFocus: $focused
		)
	}

}

@available(iOS 15, *)
struct FocusStateView: View {

	@Binding var name: String
	@Binding var username: String
	@Binding var password: String

 	@FocusState private var isNameFocused
	@FocusState private var isUsernameFocused
	@FocusState private var isPasswordFocused

	var body: some View {
		Group {
			TextField("Name", text: $name)
				.focused($isNameFocused)
				.onSubmit { isUsernameFocused = true }
			TextField("Username", text: $username)
				.focused($isUsernameFocused)
				.onSubmit { isPasswordFocused = true }
		}
		.submitLabel(.next)
		TextField("Password", text: $password)
			.focused($isPasswordFocused)
			.submitLabel(.done)
	}

}
