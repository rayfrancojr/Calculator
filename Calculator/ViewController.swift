//
//  ViewController.swift
//  Calculator
//
//  Created by Raphael A Franco on 9/3/17.
//  Copyright © 2017 Eleix. All rights reserved.
//

import UIKit
// class ViewController is a subclass of UIViewController
class ViewController: UIViewController {

    var userIsInTheMiddleOfTyping = false
    
    @IBOutlet weak var display: UILabel!
    // display is an implicitly unwrapped variable
 
    // Touch Number Key
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
        let currentdisplay = display.text!
        display.text = currentdisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
  
    // this a computed variable
    var displayValue: Double {
        get
        { return Double(display.text!)! }
        set
        {display.text = String(newValue) }
    }

    private var brain = CalculatorBrain()
    
    // Touch Operation Key
    @IBAction func peformOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }

        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
}
