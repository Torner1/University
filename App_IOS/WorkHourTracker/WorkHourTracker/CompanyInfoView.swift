import SwiftUI

struct CompanyInfoView: View {
    @State private var companyName: String = ""
    @State private var companyAddress: String = ""
    @State private var companyContact: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Company Information")
                .font(.largeTitle)
                .bold()

            TextField("Company Name", text: $companyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Company Address", text: $companyAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Contact Information", text: $companyContact)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: saveCompanyInfo) {
                Text("Save")
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
    }

    func saveCompanyInfo() {
        // Save company details locally or send to backend
        print("Company Info Saved: \(companyName), \(companyAddress), \(companyContact)")
    }
}

struct CompanyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyInfoView()
    }
}
