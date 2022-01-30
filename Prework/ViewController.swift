//
//  ViewController.swift
//  Prework
//
//  Created by Ji Wang on 1/17/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    var currencyDict = ["Canada": "$",
                        "China": "¥",
                        "EU": "€",
                        "Japan": "¥",
                        "South Korea": "₩",
                        "Russia": "₽",
                        "UK": "£",
                        "US": "$"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDefaults()
        self.billAmountTextField.becomeFirstResponder()
    }
    
    func initDefaults() {
        defaults.set(0.00, forKey: "billAmount")
        defaults.set(0.15, forKey: "tipPercentage")
        let darkModeState = traitCollection.userInterfaceStyle == .dark ? true : false
        defaults.set(darkModeState, forKey: "darkModeState")
        defaults.set("US", forKey: "country")
        
        defaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDarkMode()
        checkTipSegment()
        calculateTip()
    }
    
    func checkDarkMode() {
        let currentDarkModeState = traitCollection.userInterfaceStyle == .dark ? true : false
        let newDarkModeState = defaults.bool(forKey: "darkModeState")
        if currentDarkModeState != newDarkModeState {
            overrideUserInterfaceStyle = newDarkModeState == true ? .dark : .light
        }
    }
    
    /** When view is reloaded, check if default rate is 0.15, 0.18 or 0.20. If so, move segement to that rate. */
    func checkTipSegment() {
        let matchedIndex = matchedSegmentTipRate()
        if matchedIndex != -1 {
            tipPercentageSegment.selectedSegmentIndex = matchedIndex
        }
    }
    
    func matchedSegmentTipRate() -> Int {
        let tipRate = defaults.double(forKey: "tipPercentage")
        for i in 0...2 {
            let segmentRate = parseTipRateToDouble(tipRate: tipPercentageSegment.titleForSegment(at: i)!)
            if tipRate == segmentRate {
                return i
            }
        }
        return -1
    }
    
    func calculateTip() {
        let billAmount = defaults.double(forKey: "billAmount")
        let tipPercentage = defaults.double(forKey: "tipPercentage")
        let country = defaults.string(forKey: "country")
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        defaults.synchronize()
        
        tipPercentageLabel.text = parseTipRateToString(tipRate: tipPercentage)
        tipAmountLabel.text = parseMoney(amount: String(format: "%.2f", tipAmount), country: country!)
        totalLabel.text = parseMoney(amount: String(format: "%.2f", totalAmount), country: country!)
    }
    
    @IBAction func billAmountChanged(_ sender: Any) {
        let billAmount = Double(billAmountTextField.text!) ?? 0
        defaults.set(billAmount, forKey: "billAmount")
        defaults.synchronize()
        calculateTip()
    }
    
    /** If selected, recalculate tip amount and update into defaults. */
    @IBAction func tipPercentageSegmentChanged(_ sender: Any) {
        let index = tipPercentageSegment.selectedSegmentIndex
        let rate = parseTipRateToDouble(tipRate: tipPercentageSegment.titleForSegment(at: index)!)
        defaults.set(rate, forKey: "tipPercentage")
        defaults.synchronize()
        calculateTip()
    }
    
    func parseMoney(amount: String, country: String) -> String {
        let symbol = String(currencyDict[country]!)
        let parsedMoney = symbol + amount
        return parsedMoney
    }
    
    func parseTipRateToString(tipRate: Double) -> String {
        let rateString = String(format: "%.0f%%", tipRate * 100)
        return rateString
    }
    
    func parseTipRateToDouble(tipRate: String) -> Double {
        return Double(tipRate.prefix(2))! / 100
    }
}
