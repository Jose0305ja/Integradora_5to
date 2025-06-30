import Foundation

enum TimeRange: String, CaseIterable, Hashable {
    case day = "24h"
    case last5min = "last_5min"
    case week = "last_week"
    case month = "last_month"
    case months3 = "last_3months"

    var labelKey: String {
        switch self {
        case .day: return "range_24h"
        case .last5min: return "range_last_5min"
        case .week: return "range_last_week"
        case .month: return "range_last_month"
        case .months3: return "range_last_3months"
        }
    }
}
