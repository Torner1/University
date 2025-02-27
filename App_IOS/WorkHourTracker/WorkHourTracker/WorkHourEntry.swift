import Foundation

struct WorkHourEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let hours: Int
    let description: String

    init(date: Date, hours: Int, description: String) {
        self.id = UUID()
        self.date = date
        self.hours = hours
        self.description = description
    }
}
