//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alberto on 12/5/15.
//  Copyright (c) 2015 Alberto. All rights reserved.
//

import Foundation

class CalculatorBrain
{
   private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case NullaryOperation(String, () -> Double)
    
        var description : String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .NullaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
   private var opStack = [Op]()
    
   private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷"){ $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−"){ $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.NullaryOperation("π", { M_PI }))
        
        

//        knownOps["×"] = Op.BinaryOperation("×", *)
//        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
//        knownOps["+"] = Op.BinaryOperation("+", +)
//        knownOps["−"] = Op.BinaryOperation("−"){ $1 - $0 }
//        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvalutation = evaluate(remainingOps)
                if let operand = operandEvalutation.result {
                    return (operation(operand), operandEvalutation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .NullaryOperation(_, let operation):
                return (operation(), remainingOps)
            }
        }
        return (nil, ops)
        
    }
    
    func showTrack() -> String? {
        return " ".join(opStack.map{ "\($0)"})
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = Result: \(result) with remainder: \(remainder)")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
