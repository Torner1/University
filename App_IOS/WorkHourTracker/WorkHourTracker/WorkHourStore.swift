import Foundation

class WorkHourStore: ObservableObject {
    @Published var entries: [WorkHourEntry] = [] // Stores all work entries

    private let storageKey = "workHourEntries" // Key for saving data in UserDefaults

    init() {
        loadEntries()
    }

    func addEntry(_ entry: WorkHourEntry) {
        entries.append(entry)
        saveEntries()
    }

    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets) // Remove the entry
        saveEntries() // Save the updated entries
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([WorkHourEntry].self, from: savedData) {
            entries = decoded
        }
    }
}
