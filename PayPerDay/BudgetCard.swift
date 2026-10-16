import SwiftUI

struct BudgetCard: View {
    let budget: Budget
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(budget.name).font(.headline)
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.borderless)
            }
            Text(budget.balance, format: .currency(code: "USD"))
                .font(.title2)
            Text("+\(budget.dailyPay, format: .currency(code: "USD")) per day")
                .font(.caption)
            Text("\(budget.amount, format: .currency(code: "USD")) \(budget.scheduleText)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(width: 190)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}
