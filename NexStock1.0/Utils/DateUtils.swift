import Foundation

func formattedDate(_ iso: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: iso) {
        let display = DateFormatter()
        display.dateFormat = "dd MMM yyyy, HH:mm"
        return display.string(from: date)
    }
    return iso
}
