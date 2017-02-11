//
//  ViewController.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/8/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation

typealias completion = (_ errorMessage: String?) -> ()

class CalculatorVC: UIViewController {

    @IBOutlet weak var equationLabel: UITextView!
    @IBOutlet weak var solutionLabel: UILabel!
    @IBOutlet weak var pinMessageLabel: UILabel!
    
    @IBOutlet weak var divison: UIButton!
    @IBOutlet weak var multiplication: UIButton!
    @IBOutlet weak var subtraction: UIButton!
    @IBOutlet weak var addition: UIButton!
    @IBOutlet weak var equal: UIButton!
    @IBOutlet weak var negative: UIButton!
    
    var finalSolution: Float! = 0
    var tempSolution: Float! = 0
    var isPasswordSet = false
    var tempPassword = ""
    var password = ""
    
    let numbers = [".","0","1","2","3","4","5","6","7","8","9", "S"]
    let numbersIncludeNegative = ["-",".","0","1","2","3","4","5","6","7","8","9", "S"] // first one is negative
    let operators = ["=","+","−","×","÷","^"]
    let operatorsIncludeNegative = ["=","+","−","×","÷","^","-"] // last one is negative
    let operatorsExcludeEqual = ["+","−","×","÷"]
    let operatorsIncludeExponentExcludeEqual = ["+","−","×","÷","^"]
    let higherOrderOperation = ["×","÷"]
    let lowerOrderOperation = ["+","−","="]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isPasswordSet {
            solutionLabel.isHidden = true
            pinMessageLabel.isHidden = false
            negative.layer.borderWidth = 3
            negative.layer.borderColor = UIColor.orange.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isPasswordSet {
            let ac = UIAlertController(title: "Instructions", message: "Select a pin and press the (-) button to continue.\n \n Once set up, you will use the (-) to unlock your secret vault", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion:nil)
        }
    }
    
    // Automatically scroll the textView
    override func viewWillLayoutSubviews() {
        let range = NSMakeRange(lastIndexInEquation(), 0)
        equationLabel.scrollRangeToVisible(range)
    }

    @IBAction func numberTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        if !isPasswordSet {
            if sender.currentTitle == "." {
                return
            }
        }
        
        if equationLabel.text != ""{
            if isEndOfEquationAnEqualSign() {
                clearLabel()
            }
        }
        equationLabel.text! += sender.currentTitle!
    }
    @IBAction func DELTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        if equationLabel.text != "" {
            if equationLabel.text[equationLabel.text.characters.index(before: equationLabel.text.endIndex)] == "S" {
                equationLabel.text.removeSubrange(equationLabel.text.characters.index(equationLabel.text.endIndex, offsetBy: -3) ..< equationLabel.text.endIndex)
            } else {
                equationLabel.text.remove(at: equationLabel.text.characters.index(before: equationLabel.text.endIndex))
            }
        }
    }
    
    @IBAction func DELHolded(_ sender: Any) {
        solutionLabel.text = "0"
        equationLabel.text = ""
    }
    
    @IBAction func negativeTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
    
        if password != "" && password == equationLabel.text {
            performSegue(withIdentifier: "toStorageVC", sender: nil)
        }
        
        if !isPasswordSet && tempPassword != "" {
            if equationLabel.text == tempPassword {
                password = tempPassword
                isPasswordSet = true
                tempPassword = ""
                solutionLabel.isHidden = false
                pinMessageLabel.isHidden = true
                performSegue(withIdentifier: "toStorageVC", sender: nil)
            } else {
                pinMessageLabel.text = "Mismatch. Reset password"
                tempPassword = ""
                equationLabel.text = ""
                return
            }
        } else if !isPasswordSet {
            if equationLabel.text.characters.count < 4 {
                pinMessageLabel.text = "Minimum 4 characters"
                equationLabel.text = ""
                return
            } else {
                tempPassword = equationLabel.text
                equationLabel.text = ""
                pinMessageLabel.text = "Confirm your pin"
                return
            }
        }
        
        if equationLabel.text != ""{
            if isEndOfEquationAnEqualSign() {
                clearLabel()
                equationLabel.text! += "-"
            } else if !isInputCharacterAnOperator(inputCharacter: lastCharacterInEquation(), listOfOperations: numbersIncludeNegative) {
                equationLabel.text! += "-"
            }
        }
        else{
            equationLabel.text! += "-"
        }
    }
    
    @IBAction func ANSTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        if !isPasswordSet {
            return
        }
        
        if equationLabel.text != "" {
            if isEndOfEquationAnEqualSign() {
                clearLabel()
                equationLabel.text! += "ANS"
            } else if !isInputCharacterAnOperator(inputCharacter: lastCharacterInEquation(), listOfOperations: numbers) {
                equationLabel.text! += "ANS"
            }
        } else {
            equationLabel.text! += "ANS"
        }
    }
    
    @IBAction func performOperator(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        if !isPasswordSet {
            return
        }
        
        if equationLabel.text != ""{
            if !isInputCharacterAnOperator(inputCharacter: lastCharacterInEquation(), listOfOperations: operatorsIncludeNegative) {
                equationLabel.text! += sender.currentTitle!
            }
            if isEndOfEquationAnEqualSign() {
                clearLabel()
                equationLabel.text! += ("ANS" + sender.currentTitle!)
            }
        }
    }
    
    @IBAction func equalTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        
        if !isPasswordSet {
            return
        }
        
        if equationLabel.text != "" {
            if isInputAnOperator(input: lastCharacterInEquation(), listOfOperations: operatorsIncludeNegative) {
                return
            } else {
                equationLabel.text! += "="
                solutionLabel.text = formatOutput(convert: String(calculate()))
            }
        }
    }
    
    func clearLabel() {
        if equationLabel.text == "" {
            solutionLabel.text = ""
        } else {
            equationLabel.text = ""
        }
    }
    
    func isInputCharacterAnOperator(inputCharacter: String, listOfOperations: [String]) -> Bool {
        for i in listOfOperations {
            if inputCharacter == i {
                return true
            }
        }
        return false
    }
    
    func isInputAnOperator(input: String, listOfOperations: [String]) -> Bool {
        for i in input.characters {
            for j in listOfOperations {
                if String(i) == j {
                    return true
                }
            }
        }
        return false
    }
    
    func isEndOfEquationAnEqualSign() -> Bool {
        if lastCharacterInEquation() == "=" { return true }
        return false
    }
        
    func calculate() -> Float {
        var input1: Float!
        var input2: Float!
        var operatorPosition: Int!
        var startPosition: Int!
        var endPosition: Int!
        var operation = "A"
        var listToBeNotIn = [String]()
        var listToBeIn = [String]()
        
        equationLabel.text = equationLabel.text.replacingOccurrences(of: "ANS", with: String(finalSolution))
        equationLabel.text = equationLabel.text.replacingOccurrences(of: "e+", with: String("e"))
        equationLabel.text = equationLabel.text.replacingOccurrences(of: "--", with: String(""))
        
        //loop to read the string of operations
        while isInputAnOperator(input: equationLabel.text, listOfOperations: operatorsIncludeExponentExcludeEqual) {
            
            startPosition = 0
            
            //Determines order of operation
            if isInputAnOperator(input: equationLabel.text, listOfOperations: ["^"]) {
                listToBeNotIn = operatorsExcludeEqual
                listToBeIn = ["^"]
                
            } else if isInputAnOperator(input: equationLabel.text, listOfOperations: higherOrderOperation) {
                //Cases with higher precedence
                
                listToBeNotIn = lowerOrderOperation
                listToBeIn = higherOrderOperation
            } else {
                listToBeNotIn = [""]
                listToBeIn = lowerOrderOperation
            }
            
            //Main 2 loops that determine inputs
            for i in 0 ..< equationLabel.text.characters.count {
                
                if isInputCharacterAnOperator(inputCharacter: equationLabel.text[i], listOfOperations: listToBeNotIn) {
                    startPosition = i + 1
                }
                
                if isInputCharacterAnOperator(inputCharacter: equationLabel.text[i], listOfOperations: listToBeIn) {
                    input1 = Float(equationLabel.text[startPosition ..< i])
                    operation = equationLabel.text[i]
                    operatorPosition = i + 1
                    break
                }
            }
            
            for j in operatorPosition ..< equationLabel.text.characters.count {
                if isInputCharacterAnOperator(inputCharacter: equationLabel.text[j], listOfOperations: operators) {
                    input2 = Float(equationLabel.text[operatorPosition..<j])
                    endPosition = j
                    break
                }
            }
            
            switch operation {
                case "+": tempSolution = input1 + input2
                case "−": tempSolution = input1 - input2
                case "×": tempSolution = input1 * input2
                case "÷": tempSolution = input1 / input2
                case "^": tempSolution = pow(input1,input2)
                default: tempSolution = nil
            }
            
            equationLabel.text = equationLabel.text.replacingOccurrences(of: equationLabel.text[startPosition ..< endPosition], with: String(tempSolution))
            equationLabel.text = equationLabel.text.replacingOccurrences(of: "e+", with: String("e"))
            print(equationLabel)
        }
        
        finalSolution = Float(equationLabel.text[0 ..< lastIndexInEquation()])
        equationLabel.text = equationLabel.text.replacingOccurrences(of: equationLabel.text[0 ..< lastIndexInEquation()], with: "ANS")
        return finalSolution
    }

    func formatOutput(convert value: String!) -> String {
        guard value != nil else { return "0" }
        let doubleValue = Double(value) ?? 0.0
        let formatter = NumberFormatter()
        
        if value.characters.count > 8 {
            formatter.numberStyle = .scientific
        } else {
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 3
        }
        return formatter.string(from: NSNumber(value: doubleValue))!
    }
    
    func lastIndexInEquation() -> Int { return equationLabel.text.characters.count - 1 }
    func lastCharacterInEquation() -> String { return equationLabel.text[lastIndexInEquation()] }
    
}

