//
//  ViewController.swift
//  Calculator
//
//  Created by Simon Hogg on 2/2/15.
//  Copyright (c) 2015 Simon Hogg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var displayNegativeNumber = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if ((digit != ".") || (digit == ".") && (display.text!.rangeOfString(".") == nil)) {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func digitModifier(sender: UIButton) {
        if let modifier = sender.currentTitle {
            switch modifier {
            case "⌫":
                if countElements(display.text!) > 1 { display.text! = dropLast(display.text!) }
            case "±":
                if userIsInTheMiddleOfTypingANumber {
                    displayNegativeNumber = !displayNegativeNumber
                    if displayNegativeNumber {
                        // we are now displaying a negative number, add the sign
                        display.text! = "-" + display.text!
                    } else {
                        // we used to be, but are no longer displaying a negative number
                        display.text! = dropFirst(display.text!)
                    }
                } else {
                    displayValue = brain.performOperation("±")
                }
            default:
                    break
            }
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.pushOperand(displayValue!)
    }
    
    
    @IBAction func clearEverything() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clearEverything()
        displayValue = nil
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if let value = newValue {
                display.text = "\(value)"
                displayNegativeNumber = newValue < 0
            } else {
                display.text = ""
                displayNegativeNumber = false
            }
            history.text = brain.getHistoryString()

        }
    }
}

