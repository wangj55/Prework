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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentTipPercentage = defaults.double(forKey: "tipPercentage")
        let intTipPercentage = Int(currentTipPercentage * 100)
        
        tipPercentageLabel.text = String(format: "%i%%", intTipPercentage)
        tipPercentageSlider.value = Float(currentTipPercentage)
        defaults.synchronize()
        
        checkDarkMode()
        setDarkModeSwitch()
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

    @IBAction func enableDarkMode(_ sender: Any) {
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
