//
//  IntervalPreset.swift
//  PayPerDay
//
//  Created by Swetha Mandaleeka on 10/16/26.
//

import Foundation

enum IntervalPreset: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case custom = "Custom"

    var id: String { rawValue }

    var component: Calendar.Component? {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        case .custom: return nil
        }
    }

    func endDate(from start: Date) -> Date? {
        guard let component else { return nil }
        let cal = Calendar.current
        guard let next = cal.date(byAdding: component, value: 1, to: cal.startOfDay(for: start)) else { return nil }
        return cal.date(byAdding: .day, value: -1, to: next)
    }
}
