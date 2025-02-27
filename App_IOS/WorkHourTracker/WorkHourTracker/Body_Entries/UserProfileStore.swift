import Foundation

class UserProfileStore: ObservableObject {
    @Published var profile: UserProfile = UserProfile(name: "", email: "", address: "")

    private let storageKey = "userProfile"

    init() {
        loadProfile()
    }

    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func loadProfile() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            profile = decoded
        }
    }
}
