//
//  Calculation.swift
//  CountOnMe
//
//  Created by Romain Buewaert on 11/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum OperatorType {
    case addition
    case substraction
    case multiplication
    case division

    var symbol: String {
        switch self {
        case .addition:
            return " + "
        case .substraction:
            return " - "
        case .multiplication:
            return " x "
        case .division:
            return " / "
        }
    }
}

class Calculation {
    var operation: String = ""

    private var elements: [String] {
        return operation.split(separator: " ").map { "\($0)" }
    }

//    func test() {
//        elements.reserveCapacity(10)
//    }

    private var expressionHaveResult: Bool {
        return operation.firstIndex(of: "=") != nil
    }

    private var expressionIsCorrect: Bool {
        return operation.last != " " && operation.last != nil
    }

    func addNumber(number: String) {
        if expressionHaveResult {
            operation = ""
        }
        operation.append(_: number)
    }

    func addOperator(operatorType: OperatorType, errorMessage: @escaping () -> Void) {
        if expressionIsCorrect {
            operation.append(operatorType.symbol)
        } else {
            errorMessage()
        }
    }

    private func priorityCalculation(_ calculation: [String], currentIndex: Int) -> [String] {
        var calculation = calculation
        let left = Int(calculation[currentIndex - 1])!
        let operand = calculation[currentIndex]
        let right = Int(calculation[currentIndex + 1])!
        let result: Int
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/": result = left / right
        default: fatalError("Unknown operator !")
        }
        calculation.remove(at: currentIndex)
        calculation.insert("\(result)", at: currentIndex)
        calculation.remove(at: currentIndex + 1)
        calculation.remove(at: currentIndex - 1)
        return calculation
    }

    func calcul(expressionIsNotCorrect: @escaping () -> Void) {
        if !expressionIsCorrect && elements.count < 3 {
            expressionIsNotCorrect()
        } else {
            // Create local copy of operations
            var operationsToReduce = elements

            var indexMultiplication: Int! {
                return operationsToReduce.firstIndex(of: "x")
            }
            var indexDivision: Int! {
                return operationsToReduce.firstIndex(of: "/")
            }

            // Iterate over operations while an operand still here
            while operationsToReduce.count > 1 {

                if operationsToReduce.contains("x") {
                    operationsToReduce = priorityCalculation(operationsToReduce, currentIndex: indexMultiplication)
                }

                if operationsToReduce.contains("/") {
                    operationsToReduce = priorityCalculation(operationsToReduce, currentIndex: indexDivision)
                }

                operationsToReduce = priorityCalculation(operationsToReduce, currentIndex: 1)

//                let left = Int(operationsToReduce[0])!
//                let operand = operationsToReduce[1]
//                let right = Int(operationsToReduce[2])!
//
//                let result: Int
//                switch operand {
//                case "+": result = left + right
//                case "-": result = left - right
//                default: fatalError("Unknown operator !")
//                }
//
//                operationsToReduce = Array(operationsToReduce.dropFirst(3))
//                operationsToReduce.insert("\(result)", at: 0)
            }

            operation.append(" = \(operationsToReduce.first!)")

        }
    }

}
