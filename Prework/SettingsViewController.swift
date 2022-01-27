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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let currentTipPercentage = defaults.double(forKey: "tipPercentage")
        let intTipPercentage = Int(currentTipPercentage * 100)
        tipPercentageLabel.text = String(format: "%i%%", intTipPercentage)
        tipPercentageSlider.value = Float(currentTipPercentage)
        defaults.synchronize()
    }
    
    @IBAction func changeTipPercentage(_ sender: Any) {
        let intTipPercentage = Int(tipPercentageSlider.value * 100)
        let newTipPercentage = Double(intTipPercentage) / 100
        
        tipPercentageLabel.text = String(format: "%i%%", intTipPercentage)
        
        defaults.set(newTipPercentage, forKey: "tipPercentage")
        defaults.synchronize()
    }

}
