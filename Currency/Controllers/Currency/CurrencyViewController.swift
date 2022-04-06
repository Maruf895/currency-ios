//
//  CurrencyViewController.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import UIKit

class CurrencyViewController: UIViewController {
 
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitials()
    }
    
    @IBAction func uiActions(_ sender: UIButton) {
        switch sender {
        case fromCurrencyButton: handleUIActions(.from)
        case toCurrencyButton: handleUIActions(.to)
        case swapCurrencyButton: handleUIActions(.swap)
        case detailButton: handleUIActions(.detail)
        default: break
        }
    }
}
