import SwiftUI


struct AddVaultItemView: View {

	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode

	@State private var name = ""
	@State private var username = ""
	@State private var password = ""

	@State private var focused = [true, false, false, false]

	@StateObject private var viewModel = VaultItemsViewModel.sharedInstance

	init() {
		UITableView.appearance().backgroundColor = .clear
	}

	var body: some View {

		NavigationView {

			ZStack {
				Color(colorScheme == .dark ? .black : .white)

				Form {

					Group {

						KitTextFieldView(
							tag: 0,
							placeholder: "Name",
							returnKeyType: .next,
							text: $name,
							shouldFocus: $focused
						)

						KitTextFieldView(
							tag: 1,
							placeholder: "Username",
							returnKeyType: .next,
							text: $username,
							shouldFocus: $focused
						)

						KitTextFieldView(
							tag: 2,
							placeholder: "Password",
							returnKeyType: .default,
							text: $password,
							shouldFocus: $focused
						)

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
			.navigationBarTitle("Add new item", displayMode: .inline)

		}
		.accentColor(Color.auroraColor)

	}

}
