//
//  HomeViewController.swift
//  IOS-Calculator
//
//  Created by Raquel on 28/12/22.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    // Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operators
    
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorIqual: UIButton!
    @IBOutlet weak var operatorAdd: UIButton!
    @IBOutlet weak var operatorRemove: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivisor: UIButton!
    
    
    // MARK: - Variables
    
    private var total: Double = 0
    private var temp: Double = 0
    private var operating = false
    private var decimal = false
    private var operation: OperationType = .none
    
    
    // MARK: - Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    
    private enum OperationType {
        case none, addiction, remove, multiplication, division, percent
        
    }
    
    // Formateo valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo valores totales auxiliares
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo valores por pantalla
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formateo formato científico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    
    
    // MARK: - Initialization
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorIqual.round()
        operatorAdd.round()
        operatorRemove.round()
        operatorMultiplication.round()
        operatorDivisor.round()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        result()

    }
    
    // MARK: - Button Actions

    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        
        sender.shine()
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        
        if operation != .percent {
            result()
        }
        
        operating = true
        operation = .percent
        result()
        
        sender.shine()
    }
    @IBAction func operatorIqualAction(_ sender: UIButton) {
        result()
        
        sender.shine()
    }
    @IBAction func operatorAddAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorRemoveAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .remove
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorDivisorAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {

        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        sender.shine()
    }
    
    // Clear values
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
        
    }
    // Get final result
    private func result(){
        switch operation {
            
        case .none:
            break
        case .addiction:
            total = total + temp
            break
        case .remove:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        // Formateo en pantalla
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        selectVisualOperation()
        
    }
    
    private func selectVisualOperation(){
        if !operating {
            operatorAdd.selectOperation(false)
            operatorRemove.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivisor.selectOperation(false)
            
        } else {
            switch operation {
                
            case .none, .percent:
                operatorAdd.selectOperation(false)
                operatorRemove.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivisor.selectOperation(false)
                break
                
            case .addiction:
                operatorAdd.selectOperation(true)
                operatorRemove.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivisor.selectOperation(false)
                
                break
            case .remove:
                operatorAdd.selectOperation(false)
                operatorRemove.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivisor.selectOperation(false)
                
                break
            case .multiplication:
                operatorAdd.selectOperation(false)
                operatorRemove.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivisor.selectOperation(false)
                
                break
            case .division:
                operatorAdd.selectOperation(false)
                operatorRemove.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivisor.selectOperation(true)
                
                break
           
                
            }
        }
    }
    
}
