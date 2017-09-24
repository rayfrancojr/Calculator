//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Raphael A Franco on 9/5/17.
//  Copyright © 2017 Eleix. All rights reserved.
//

// Xcode 9 has line numbers that I like

import Foundation


// This is the Model and it is UI independent
struct CalculatorBrain {
    
    private var accumulator: Double?
 
    // enums in Swift can have associated values
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->(Double))
        case binaryOperation((Double, Double)->Double)
        case equals
    }
    // This code uses closurers {inline code}
    private var operations: Dictionary<String, Operation> = [
        "π"   : Operation.constant(Double.pi),
        "e"   : Operation.constant(M_E),
        "√"   : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±"   : Operation.unaryOperation({-$0}),
        "×"   : Operation.binaryOperation({$0 * $1}),
        "÷"   : Operation.binaryOperation({$0 / $1}),
        "+"   : Operation.binaryOperation({$0 + $1}),
        "-"   : Operation.binaryOperation({$0 - $1}),
        "="   : Operation.equals
    ]
    
    
    mutating func performOperation(_ symbol: String) {
        if let operation  = operations[symbol] {
            switch operation {
            case .constant (let value) :
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
    
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }


    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
 
    
}
