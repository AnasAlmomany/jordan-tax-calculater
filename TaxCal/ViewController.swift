//
//  ViewController.swift
//  TaxCal
//
//  Created by Anas Almomany on 22/03/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var exemptions: UITextField!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func calculateTapped(_ sender: UIButton) {
        calculate()
    }

    func calculate(){
        var profiles: [CompanyIncomeAndTax] = []
        let salary: Double = (Double(textField.text!) ?? 0)/12

        var str = ""
        str += "Monthly Salary : \(salary) \n"
        profiles.append(CompanyIncomeAndTax(income: salary*12)) // Totals

        let incomeTotal = profiles.map{ $0.income }.reduce(0, +)
        str += "Total Income : : \(incomeTotal) \n"

        let taxEligibaleIncome = incomeTotal - (Double(exemptions.text!) ?? 0)
        let reminder = taxEligibaleIncome.truncatingRemainder(dividingBy: 5000.0)

        let fixed = taxEligibaleIncome - reminder
        var taxes: Double = 0

        switch taxEligibaleIncome {
        case 0...5000 :
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
        default: print(fixed)
        }

        str += "Expected Taxes : \(taxes) \n"
        str += "Expected Monthly Taxes : \(taxes/12) \n"
        str += "Total without Taxes : \(incomeTotal - taxes) \n"

        let socialSecurity: Double = 0.075
        let monthlySocialSecurity: Double = (incomeTotal/12) * socialSecurity

        str += "Monthly social security : \(monthlySocialSecurity) \n"

        let totalDeductions =  monthlySocialSecurity + (taxes/12)
        str += "Total Monthly Deductions : \(totalDeductions) \n"
        str += "Salary after deductions  : \((incomeTotal/12) - totalDeductions) \n"

        label.text = str
    }
}




struct CompanyIncomeAndTax {
    var income: Double
}

