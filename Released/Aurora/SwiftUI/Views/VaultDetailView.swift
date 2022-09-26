import SwiftUI


struct VaultDetailView: View {

	@AppStorage("isSecured") private var isSecured = false

	@Environment(\.colorScheme) private var colorScheme

	@State private var shouldShowToast = false

	let vaultItem: VaultItems

	var body: some View {

		VStack {
			Form {
				Group {
					Text("Name: \(vaultItem.name)")
					Text("Username: \(vaultItem.username)")
					Text("Password: \(isSecured ? "••••••••" : vaultItem.password)")
				}
				.font(.headline)
				.listRowBackground(colorScheme == .dark ? Color.black : Color.white)
			}
			.disabled(true)
			.padding(.top, -20)

			if shouldShowToast {

				Text("Copied")
					.font(.system(size: 18))
					.frame(width: 100, height: 40)
					.background(Color.auroraColor)
					.transition(.opacity.combined(with: .scale))
					.clipShape(Capsule(style: .continuous))
 					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
							withAnimation(.easeInOut(duration: 0.5)) {
								shouldShowToast.toggle()
							}
						}
					}

			}
		}
		.padding()
		.navigationBarTitle(Text(vaultItem.name), displayMode: .inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				HStack {
					Button {
						isSecured.toggle()
					} label: {
						Image(systemName: isSecured ? "eye.slash.fill" : "eye.fill")
					}
					Button {
						withAnimation(.easeInOut(duration: 0.5)) {
							shouldShowToast.toggle()
						}
						UIPasteboard.general.string = vaultItem.password
					} label: {
						Image(systemName: "paperclip")
							.font(.system(size: 20))
					}
				}
			}
		}

	}

}
