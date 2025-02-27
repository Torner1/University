import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var selectedDate = Date() // Selected date for work entry
    @State private var selectedHours: Int? = nil // Selected hours worked
    @State private var description: String = "" // Work description
    @EnvironmentObject var store: WorkHourStore // Access the shared data store
    @EnvironmentObject var userProfileStore: UserProfileStore // Access user profile

    @State private var companyName: String = "My Company"
    @State private var companyAddress: String = "1234 Main St, City, Country"
    @State private var companyContact: String = "contact@company.com"
    @State private var ratePerHour: Double = 20.0 // Example hourly rate

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Hour Selection Buttons
                Text("Select Hours Worked")
                    .font(.headline)
                HStack(spacing: 10) {
                    ForEach(1...10, id: \.self) { hour in
                        Button(action: { selectedHours = hour }) {
                            Text("\(hour) hr")
                                .frame(width: 50, height: 50)
                                .background(selectedHours == hour ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }

                // Date Picker
                DatePicker("Select Work Day", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()

                // Description Input
                TextField("Enter a description (optional)", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Save Button
                Button(action: saveWorkHours) {
                    Text("Save Entry")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedHours == nil) // Disable button until hours are selected

                // List of Saved Entries
                Text("Saved Entries")
                    .font(.headline)
                    .padding(.top)

                List {
                    ForEach(store.entries) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.date, style: .date)
                                .font(.headline)
                            Text("Hours: \(entry.hours)")
                            if !entry.description.isEmpty {
                                Text(entry.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteEntry) // Enable swipe-to-delete
                }
                .listStyle(PlainListStyle())

                // Generate Invoice Button
                Button(action: generateInvoice) {
                    Text("Generate Invoice")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle("Work Hours Tracker")
        }
    }

    // Save a new work entry
    func saveWorkHours() {
        guard let hours = selectedHours else { return }
        let entry = WorkHourEntry(date: selectedDate, hours: hours, description: description)
        store.addEntry(entry)
        selectedHours = nil
        description = ""
    }

    // Delete an existing work entry
    func deleteEntry(at offsets: IndexSet) {
        store.deleteEntry(at: offsets)
    }

    // Generate an invoice as a PDF
    func generateInvoice() {
        let pdfDocument = PDFDocument()
        let pdfPage = PDFPage(image: renderInvoiceImage(
            companyName: companyName,
            companyAddress: companyAddress,
            companyContact: companyContact,
            ratePerHour: ratePerHour
        ))
        pdfDocument.insert(pdfPage!, at: 0)

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("WorkHoursInvoice.pdf")
        pdfDocument.write(to: fileURL)

        sharePDF(fileURL: fileURL)
    }

    // Render the invoice as an image
    func renderInvoiceImage(companyName: String, companyAddress: String, companyContact: String, ratePerHour: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 595, height: 842)) // A4 dimensions: 595x842 points
        return renderer.image { context in
            let pageWidth: CGFloat = 595
            let margin: CGFloat = 40

            // Header: User and Company Information
            let userProfile = userProfileStore.profile
            userProfile.name.draw(at: CGPoint(x: margin, y: margin), withAttributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.black
            ])
            userProfile.address.draw(at: CGPoint(x: margin, y: margin + 25), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ])
            userProfile.email.draw(at: CGPoint(x: margin, y: margin + 45), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ])

            // Company Information
            companyName.draw(at: CGPoint(x: margin, y: margin + 80), withAttributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.black
            ])
            companyAddress.draw(at: CGPoint(x: margin, y: margin + 105), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ])
            companyContact.draw(at: CGPoint(x: margin, y: margin + 125), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ])

            // Invoice Title
            let title = "Invoice"
            title.draw(at: CGPoint(x: pageWidth / 2 - 50, y: margin + 150), withAttributes: [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.black
            ])

            // Table Headers
            let headers = ["Date", "Hours", "Rate/Hour", "Total"]
            let columnWidths: [CGFloat] = [120, 80, 120, 120] // Column widths for Date, Hours, Rate/Hour, and Total
            var yOffset: CGFloat = margin + 200

            for (index, header) in headers.enumerated() {
                header.draw(at: CGPoint(x: margin + columnWidths[..<index].reduce(0, +), y: yOffset), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                    .foregroundColor: UIColor.black
                ])
            }

            // Table Rows
            let rowFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            yOffset += 30 // Space between headers and first row
            var totalAmountDue: Double = 0.0

            for entry in store.entries {
                let dateString = DateFormatter.localizedString(from: entry.date, dateStyle: .short, timeStyle: .none)
                let hours = entry.hours
                let amount = Double(hours) * ratePerHour
                totalAmountDue += amount

                let rowData = [dateString, "\(hours)", String(format: "%.2f", ratePerHour), String(format: "%.2f", amount)]

                for (index, text) in rowData.enumerated() {
                    text.draw(at: CGPoint(x: margin + columnWidths[..<index].reduce(0, +), y: yOffset), withAttributes: [
                        .font: rowFont,
                        .foregroundColor: UIColor.black
                    ])
                }
                yOffset += 25 // Space between rows
            }

            // Footer: Total Amount Due
            let totalText = "Total Amount Due: \(String(format: "%.2f", totalAmountDue))"
            totalText.draw(at: CGPoint(x: margin, y: yOffset + 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.black
            ])

            // Footer: Thank You Message
            let thankYouMessage = "Thank you for your business!"
            thankYouMessage.draw(at: CGPoint(x: margin, y: 800), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ])
        }
    }

    // Share the generated PDF
    func sharePDF(fileURL: URL) {
        let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityController, animated: true, completion: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(WorkHourStore()).environmentObject(UserProfileStore())
    }
}
