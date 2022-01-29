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
    @IBOutlet weak var totalLabel: UILabel!
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
        calculateTip()
    }
    
    func checkDarkMode() {
        let currentDarkModeState = traitCollection.userInterfaceStyle == .dark ? true : false
        let newDarkModeState = defaults.bool(forKey: "darkModeState")
        if currentDarkModeState != newDarkModeState {
            overrideUserInterfaceStyle = newDarkModeState == true ? .dark : .light
        }
    }
    
    func calculateTip() {
        let billAmount = defaults.double(forKey: "billAmount")
        let tipPercentage = defaults.double(forKey: "tipPercentage")
        let country = defaults.string(forKey: "country")
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        defaults.synchronize()
        
        tipAmountLabel.text = parseMoney(amount: String(format: "%.2f", tipAmount), country: country!)
        totalLabel.text = parseMoney(amount: String(format: "%.2f", totalAmount), country: country!)
    }
    
    @IBAction func billAmountChanged(_ sender: Any) {
        let billAmount = Double(billAmountTextField.text!) ?? 0
        defaults.set(billAmount, forKey: "billAmount")
        defaults.synchronize()
        calculateTip()
    }
    
    func parseMoney(amount: String, country: String) -> String {
        let symbol = String(currencyDict[country]!)
        let parsedMoney = symbol + amount
        return parsedMoney
    }
}
