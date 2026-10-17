import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var amount: Double?
    @State private var preset: IntervalPreset = .year
    @State private var startDate = Date()
    @State private var customEnd = Calendar.current.date(byAdding: .day, value: 29, to: Date()) ?? Date()
    @State private var recurring = true
    @State private var budgets: [Budget] = []

    var endDate: Date {
        preset == .custom ? customEnd : (preset.endDate(from: startDate) ?? startDate)
    }

    var rangeIsValid: Bool {
        Calendar.current.startOfDay(for: endDate) >= Calendar.current.startOfDay(for: startDate)
    }


    var draft: Budget? {
        guard let amount, amount > 0, rangeIsValid else { return nil }
        return Budget(name: name, amount: amount, startDate: startDate, endDate: endDate, recurring: recurring)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("PayPerDay")
                .font(.largeTitle)

            TextField("Name", text: $name, prompt: Text("Name of Category"))
            TextField("Amount", value: $amount, format: .number, prompt: Text("Amount over the Interval"))

            Picker("Interval", selection: $preset) {
                ForEach(IntervalPreset.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)

            DatePicker("From", selection: $startDate, displayedComponents: .date)

            if preset == .custom {
                DatePicker("To", selection: $customEnd, displayedComponents: .date)
            } else {
                HStack {
                    Text("To")
                    Spacer()
                    Text(endDate.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.secondary)
                }
            }

            Toggle("Repeat after it ends", isOn: $recurring)
                .toggleStyle(.checkbox)

            if !rangeIsValid {
                Text("The end date must be on or after the start date")
                    .foregroundStyle(.red)
            } else if let draft {
                Text("You'll be paid \(draft.dailyPay, format: .currency(code: "USD")) per day for \(draft.lengthDays) days")
            } else {
                Text("Enter an amount to see your daily pay")
                    .foregroundStyle(.secondary)
            }

            Button("Add Budget", action: addBudget)
                .disabled(draft == nil || name.isEmpty)

            Spacer()

            if budgets.isEmpty {
                Text("No budgets yet").foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(budgets) { budget in
                            BudgetCard(budget: budget) { delete(budget) }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(minWidth: 480, minHeight: 540)
    }

    func addBudget() {
        guard let draft else { return }
        budgets.append(draft)
        name = ""
        amount = nil
    }

    func delete(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
    }
}

#Preview {
    ContentView()
}
#Preview {
    ContentView()
}
