//
//  ContentView.swift
//  Jordan tax
//
//  Created by Anas Almomany on 21/03/2023.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var salaryText: String = ""
    @State private var exemptionsText: String = ""
    @State private var results: [String: Double] = [:]
    @State private var showResultsView: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Salary")) {
                    TextField("Enter annual salary", text: $salaryText)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Exemptions")) {
                    TextField("Enter exemptions", text: $exemptionsText)
                        .keyboardType(.decimalPad)
                }
                Button(action: calculateTapped) {
                    Text("Calculate")
                }
            }
            .navigationBarTitle("Tax Calculator")
            .sheet(isPresented: $showResultsView) {
                ResultsView(results: results)
            }
        }
    }

    func calculateTapped() {
        calculate()
        showResultsView = true
    }

    func calculate() {
        var profiles: [CompanyIncomeAndTax] = []
        let salary: Double = (Double(salaryText) ?? 0) / 12

        profiles.append(CompanyIncomeAndTax(income: salary * 12)) // Totals

        let incomeTotal = profiles.map { $0.income }.reduce(0, +)

        let taxEligibaleIncome = incomeTotal - (Double(exemptionsText) ?? 0)
        let reminder = taxEligibaleIncome.truncatingRemainder(dividingBy: 5000.0)

        let fixed = taxEligibaleIncome - reminder
        var taxes: Double = 0

        switch taxEligibaleIncome {
        case 0...5000:
            taxes = 250
            taxes = taxes + (0.05 * (taxEligibaleIncome - 5000))
        case 5001...10000:
            taxes = 750
            taxes = taxes + (0.1 * (taxEligibaleIncome - 10000))
        case 10001...15000:
            taxes = 1500
            taxes = taxes + (0.15 * (taxEligibaleIncome - 15000))
        case 15001...20000:
            taxes = 2500
            taxes = taxes + (0.2 * (taxEligibaleIncome - 20000))
        case 20001...980000:
            taxes = 3750
            taxes = taxes + (0.25 * (taxEligibaleIncome - 25000))
        default:
            print(fixed)
        }

        let socialSecurity: Double = 0.075
        let monthlySocialSecurity: Double = (incomeTotal / 12) * socialSecurity

        let totalDeductions = monthlySocialSecurity + (taxes / 12)

        results["Monthly Salary"] = salary
        results["Total Income"] = incomeTotal
        results["Expected Taxes"] = taxes
        results["Expected Monthly Taxes"] = taxes / 12
        results["Total without Taxes"] = incomeTotal - taxes
        results["Monthly social security"] = monthlySocialSecurity
        results["Total Monthly Deductions"] = totalDeductions
        results["Salary after deductions"] = (incomeTotal / 12) - totalDeductions
    }
}

struct ResultsView: View {
    let results: [String: Double]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                ForEach(results.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text(key)
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(results[key]!, specifier: "%.2f")")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("Results", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the view
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
