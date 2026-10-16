import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var amount: Double?
    @State private var every = 1
    @State private var unit: TimeUnit = .years
    @State private var startDate = Date()
    @State private var budgets: [Budget] = []

    var draft: Budget? {
        guard let amount, amount > 0 else { return nil }
        return Budget(name: name, amount: amount, every: every, unit: unit, startDate: startDate)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("PayPerDay")
                .font(.largeTitle)

            TextField("Name", text: $name, prompt: Text("Name of Category"))
            TextField("Amount", value: $amount, format: .number, prompt: Text("Amount over one interval"))

            HStack {
                Stepper("Interval: \(every)", value: $every, in: 1...365)
                Picker("Unit", selection: $unit) {
                    ForEach(TimeUnit.allCases) { Text($0.rawValue).tag($0) }
                }
                .labelsHidden()
            }

            DatePicker("Start date", selection: $startDate, displayedComponents: .date)

            if let draft {
                Text("You'll be paid \(draft.dailyPay, format: .currency(code: "USD")) per day")
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
        .frame(minWidth: 440, minHeight: 480)
    }

    func addBudget() {
        guard let draft else { return }
        budgets.append(draft)
        name = ""
        amount = nil
        every = 1
    }

    func delete(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
    }
}

#Preview {
    ContentView()
}
