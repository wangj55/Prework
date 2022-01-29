//
//  SettingsViewController.swift
//  Prework
//
//  Created by Ji Wang on 1/26/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipPercentageSlider: UISlider!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    var selectedCountry: String?
    var currencyDict = ["Canada": "$",
                        "China": "¥",
                        "EU": "€",
                        "Japan": "¥",
                        "South Korea": "₩",
                        "Russia": "₽",
                        "UK": "£",
                        "US": "$"]
    var countries = ["Canada", "China", "EU", "Japan", "South Korea", "Russia", "UK", "US"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentTipPercentage = defaults.double(forKey: "tipPercentage")
        let intTipPercentage = Int(currentTipPercentage * 100)
        let country = defaults.string(forKey: "country")
        
        tipPercentageLabel.text = String(format: "%i%%", intTipPercentage)
        tipPercentageSlider.value = Float(currentTipPercentage)
        countryTextField.text = country
        symbolLabel.text = currencyDict[country!]
        defaults.synchronize()
        
        checkDarkMode()
        setDarkModeSwitch()
        
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
    }
    
    func createAndSetupPickerView() {
        let countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        self.countryTextField.inputView = countryPicker
    }
    
    func dismissAndClosePickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.countryTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissAction() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        setDarkModeSwitch()
    }
    
    @IBAction func changeTipPercentage(_ sender: Any) {
        let intTipPercentage = Int(tipPercentageSlider.value * 100)
        let newTipPercentage = Double(intTipPercentage) / 100
        
        tipPercentageLabel.text = String(format: "%i%%", intTipPercentage)
        
        defaults.set(newTipPercentage, forKey: "tipPercentage")
        defaults.synchronize()
    }
    
    func checkDarkMode() {
        let currentDarkModeState = traitCollection.userInterfaceStyle == .dark ? true : false
        let newDarkModeState = defaults.bool(forKey: "darkModeState")
        if currentDarkModeState != newDarkModeState {
            overrideUserInterfaceStyle = newDarkModeState == true ? .dark : .light
        }
    }
    
    func setDarkModeSwitch() {
        let darkModeState = defaults.bool(forKey: "darkModeState")
        if darkModeState == true {
            darkModeSwitch.isOn = true
        } else {
            darkModeSwitch.isOn = false
        }
    }

    @IBAction func enableDarkModeSwitch(_ sender: Any) {
        let darkModeState = darkModeSwitch.isOn
        
        defaults.set(darkModeState, forKey: "darkModeState")
        defaults.synchronize()
        
        if darkModeState {
            overrideUserInterfaceStyle = .dark
            print("change to dark mode")
        } else {
            overrideUserInterfaceStyle = .light
            print("change to light mode")
        }
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = self.countries[row]
        self.countryTextField.text = self.selectedCountry
        self.symbolLabel.text = self.currencyDict[self.selectedCountry!]
        defaults.set(self.selectedCountry, forKey: "country")
        defaults.synchronize()
    }
}
