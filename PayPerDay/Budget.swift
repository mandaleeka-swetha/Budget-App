//
//  Budget.swift
//  PayPerDay
//
//  Created by Swetha Mandaleeka on 10/15/26.
//

import Foundation

struct Budget: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var startDate: Date
    var endDate: Date
    var recurring: Bool

    private func daysBetween(_ a: Date, _ b: Date) -> Int {
        let cal = Calendar.current
        return cal.dateComponents([.day], from: cal.startOfDay(for: a), to: cal.startOfDay(for: b)).day ?? 0
    }

    var lengthDays: Int { max(1, daysBetween(startDate, endDate) + 1) }


    private var daysPaid: Int { max(0, daysBetween(startDate, Date()) + 1) }

    var dailyPay: Double { amount / Double(lengthDays) }


    var balance: Double {
        let paid = recurring ? daysPaid : min(daysPaid, lengthDays)
        return Double(paid) * dailyPay
    }

    var isFinished: Bool { !recurring && daysPaid >= lengthDays }

    var intervalText: String {
        let start = startDate.formatted(date: .abbreviated, time: .omitted)
        let end = endDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) – \(end)" + (recurring ? " · repeats" : "")
    }
}
