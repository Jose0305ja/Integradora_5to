import Foundation

func formattedDate(from isoString: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: isoString) {
        let output = DateFormatter()
        output.dateFormat = "dd MMM yyyy, HH:mm"
        return output.string(from: date)
    }
    return isoString
}
