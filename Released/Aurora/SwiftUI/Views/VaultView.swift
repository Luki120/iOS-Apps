import SwiftUI


struct VaultView: View {

	@State private var shouldShowAddVaultItemViewSheet = false

	@StateObject private var viewModel = VaultItemsViewModel.sharedInstance

	init() {
 		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().backgroundColor = .systemBackground
	}

	var body: some View {

		NavigationView {
			VStack {
				List {
					ForEach(viewModel.vaultItems) { item in
						NavigationLink(destination: VaultDetailView(vaultItem: item)) {
							VStack(alignment: .leading) {
								Text(item.name)
									.font(.system(size: 18))
									.foregroundColor(.primary)
							}
						}
					}
					.onDelete(perform: viewModel.remove)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							shouldShowAddVaultItemViewSheet.toggle()
						}
						label: { Image (systemName: "plus") }
					}
				}
				.navigationBarTitle("Vault", displayMode: .inline)
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.sheet(isPresented: $shouldShowAddVaultItemViewSheet) { AddVaultItemView() }
		.tabItem {
			Image(systemName: "lock.fill")
				.font(.system(size: 22))
		}

	}

}
