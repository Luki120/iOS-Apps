import SwiftUI


struct VaultView: View {

	var body: some View {

		NavigationView {

			VStack { Text("") }
				.navigationBarTitle("Vault", displayMode: .inline)

		}
		.navigationViewStyle(StackNavigationViewStyle())
		.tabItem {

			Image(systemName: "lock.fill")
			.font(.system(size: 22))

		}

	}

}
