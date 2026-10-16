//
//  Budget.swift
//  PayPerDay
//
//  Created by Swetha Mandaleeka on 10/15/26.
//

import Foundation

enum TimeUnit: String, CaseIterable, Identifiable {
    case days, weeks, months, years

    var id: String { rawValue }
    var singular: String { String(rawValue.dropLast()) }   // "years" -> "year"

    var component: Calendar.Component {
        switch self {
        case .days: return .day
        case .weeks: return .weekOfYear
        case .months: return .month
        case .years: return .year
        }
    }
}

struct Budget: Identifiable {
    
    let id = UUID()
    var name: String
    var amount: Double
    var every: Int
    var unit: TimeUnit
    var startDate: Date

    private func intervalStart(_ i: Int) -> Date {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        return calendar.date(byAdding: unit.component, value: i * every, to: start) ?? start
    }
    private func daysBetween(_ a: Date, _ b: Date) -> Int {
        Calendar.current.dateComponents([.day], from: a, to: b).day ?? 0
    }
    private func length(of i: Int) -> Int {
        max(1, daysBetween(intervalStart(i), intervalStart(i + 1)))
    }
    private var progress: (interval: Int, paidDays: Int)? {
        let today = Calendar.current.startOfDay(for: Date())
        if today < intervalStart(0) { return nil }   // hasn't started yet
        var i = 0
        while intervalStart(i + 1) <= today { i += 1 }
        return (i, daysBetween(intervalStart(i), today) + 1)
    }


    var balance: Double {
        guard let p = progress else { return 0 }
        return (Double(p.interval) + Double(p.paidDays) / Double(length(of: p.interval))) * amount
    }

    var dailyPay: Double {
        amount / Double(length(of: progress?.interval ?? 0))
    }

    var scheduleText: String {
        every == 1 ? "every \(unit.singular)" : "every \(every) \(unit.rawValue)"
    }
}
