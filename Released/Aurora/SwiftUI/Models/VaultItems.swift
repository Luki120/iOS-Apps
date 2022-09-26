import SwiftUI


final class VaultItems: Codable, Identifiable {

	var id = UUID()
	var name = ""
	var username = ""
	var password = ""

}

final class VaultItemsViewModel: ObservableObject {

	static let sharedInstance = VaultItemsViewModel()

	@Published private(set) var vaultItems: [VaultItems]

	init() {
		guard let data = UserDefaults.standard.data(forKey: "savedItems") else {
			vaultItems = []
			return	
		}

		let decodedData = try? JSONDecoder().decode([VaultItems].self, from: data)
		vaultItems = decodedData ?? []
	}

	private func saveData() {
		guard let encodedData = try? JSONEncoder().encode(vaultItems) else { return }
		UserDefaults.standard.set(encodedData, forKey: "savedItems")
	}

	func feedArray(vaultItem: VaultItems) {
		vaultItems.append(vaultItem)
		saveData()
	}

	func remove(at offsets: IndexSet) {
		vaultItems.remove(atOffsets: offsets)
		saveData()
	}

}
