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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaults.set(0.00, forKey: "billAmount")
        defaults.set(0.15, forKey: "tipPercentage")
        defaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDarkMode()
        calculateTip()
    }
    
    func checkDarkMode() {
        let currentDarkModeState = overrideUserInterfaceStyle == .dark ? true : false
        let newDarkModeState = defaults.bool(forKey: "darkModeState")
        if currentDarkModeState != newDarkModeState {
            overrideUserInterfaceStyle = newDarkModeState == true ? .dark : .light
        }
    }
    
    func calculateTip() {
        let billAmount = defaults.double(forKey: "billAmount")
        let tipPercentage = defaults.double(forKey: "tipPercentage")
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        defaults.synchronize()
        
        tipAmountLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let billAmount = Double(billAmountTextField.text!) ?? 0
        defaults.set(billAmount, forKey: "billAmount")
        defaults.synchronize()
        calculateTip()
    }
}
