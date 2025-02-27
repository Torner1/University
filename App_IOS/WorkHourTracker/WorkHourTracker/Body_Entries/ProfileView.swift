import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userProfileStore: UserProfileStore
    @State private var name: String
    @State private var email: String
    @State private var address: String

    init() {
        _name = State(initialValue: "")
        _email = State(initialValue: "")
        _address = State(initialValue: "")
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.largeTitle)
                .bold()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: saveProfile) {
                Text("Save Profile")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .onAppear {
            loadProfileData()
        }
    }

    func saveProfile() {
        userProfileStore.profile = UserProfile(name: name, email: email, address: address)
        userProfileStore.saveProfile()
    }

    func loadProfileData() {
        let profile = userProfileStore.profile
        name = profile.name
        email = profile.email
        address = profile.address
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserProfileStore())
    }
}
