import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var amount: Double?
    @State private var days: Double?
    
    var payPerDay: Double?{
        guard let amount, let days, days > 0
                else {
            return nil
        }
        return amount/days
    }
    
    var body: some View {
        VStack(spacing: 16){
            Text("PayPerDay")
                .font(.largeTitle)
            
            TextField("Amount", value: $amount, format: .number, prompt: Text("Amount Over Interval"))
            TextField("Days", value: $days, format: .number, prompt: Text("Days in Interval"))
            
            if let payPerDay {
                Text("You get paid \(payPerDay, format: .currency(code: "USD")) per day")
            } else {
                Text("Enter an amount and a number of days in your interval").foregroundStyle(.secondary)
            }
        }
        
        .padding()
        .frame(width: 320)
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
