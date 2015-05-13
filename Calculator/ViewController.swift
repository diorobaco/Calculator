//
//  ViewController.swift
//  Calculator
//
//  Created by Alberto on 11/5/15.
//  Copyright (c) 2015 Alberto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    var brain = CalculatorBrain()


    @IBAction func append(sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if !(digit == "." && (display.text!.rangeOfString(".") != nil)){
                    display.text = display.text! + digit
                }
            } else {
                userIsInTheMiddleOfTypingANumber = true
                display.text = digit
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
        }

    }
    

    @IBAction func clear(sender: AnyObject) {
        brain = CalculatorBrain()
        displayValue = 0
    }

    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.showTrack()
        }
    }

}

