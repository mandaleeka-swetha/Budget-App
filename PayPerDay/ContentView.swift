import SwiftUI
import Playgrounds


struct Budget: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var days: Double
    
    var payPerDay: Double {amount / days}
}

struct BudgetCard: View {
    let budget: Budget
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6){
            HStack {
                Text(budget.name).font(.headline)
                Spacer()
                Button(action: onDelete){
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.bordered)
            }
            Text(budget.payPerDay, format: .currency(code: "USD")).font(.title2)
            Text("per day").font(.caption).foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(width: 150)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}


struct ContentView: View {
    @State private var name = ""
    @State private var amount: Double?
    @State private var days: Double?
    @State private var budgets: [Budget] = []

    var payPerDay: Double? {
        guard let amount, let days, days > 0 else { return nil }
        return amount / days
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("PayPerDay")
                .font(.largeTitle)

            TextField("Name", text: $name, prompt: Text("Name of Category"))
            TextField("Amount", value: $amount, format: .number, prompt: Text("Amount Over Interval"))
            TextField("Days", value: $days, format: .number, prompt: Text("Days in Interval"))

            if let payPerDay {
                Text("You get paid \(payPerDay, format: .currency(code: "USD")) per day")
            } else {
                Text("Enter a name, an amount, and a number of days")
                    .foregroundStyle(.secondary)
            }

            Button("Add Budget", action: addBudget)
                .disabled(payPerDay == nil || name.isEmpty)

            Spacer()   // pushes the boxes to the bottom

            if budgets.isEmpty {
                Text("No budgets yet")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(budgets) { budget in
                            BudgetCard(budget: budget) {
                                delete(budget)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 420)
    }
    
        func addBudget() {
            guard let amount, let days, days > 0 else { return }
            budgets.append(Budget(name: name, amount: amount, days: days))
            name = ""
            self.amount = nil
            self.days = nil
        }

        func delete(_ budget: Budget) {
            budgets.removeAll { $0.id == budget.id }
        }
    }



#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
