//
//  Calculation.swift
//  CountOnMe
//
//  Created by Romain Buewaert on 11/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum OperatorType: String {
    case addition = "+"
    case substraction = "-"
    case multiplication = "x"
    case division = "/"

    fileprivate var symbol: String {
        return " \(rawValue) "
    }
}

enum CalculationError: Error {
    case operatorAlreadyPresent
    case expressionIsNotCorrect
    case divisionByZero
}

final class Calculation {
    var operation: String = ""

    // Split operation to create a table with all values and operators
    private var elements: [String] {
        return operation.split(separator: " ").map { "\($0)" }
    }

    // Verification if operation contain an "equal"
    private var expressionHaveResult: Bool {
        return operation.firstIndex(of: "=") != nil
    }

    // Verification if operation contain a value before add an operator or sign equal
    private var expressionIsCorrect: Bool {
        return operation.last != " " && operation.last != nil
    }

    // Verification if last value contain already a point
    private var lastNumberIsCorrect: Bool {
        if let number = elements.last {
            if number.contains(".") {
                return false
            }
        }
        return true
    }

    func addNumber(number: String) {
        if expressionHaveResult {
            operation = ""
        }
        operation.append(_: number)
    }

    func addPoint() throws {
        if expressionHaveResult {
            operation = ""
        }
        guard lastNumberIsCorrect else {
            throw CalculationError.expressionIsNotCorrect
        }
        operation.append(".")
    }

    private func startFromResultIfNeeded() {
        if let last = elements.last, elements.firstIndex(of: "=") != nil {
            operation = last
        }
    }

    func addOperator(operatorType: OperatorType) throws {
        guard expressionIsCorrect else {
            throw CalculationError.operatorAlreadyPresent
        }
        startFromResultIfNeeded()
        operation.append(operatorType.symbol)
    }

    private func priorityCalculation(_ calculation: [String], currentIndex: Int) throws -> [String] {
        var calculation = calculation
        let left = Double(calculation[currentIndex - 1])!
        let operand = calculation[currentIndex]
        let right = Double(calculation[currentIndex + 1])!
        let result: Double
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/":
            if right == 0 {
                throw CalculationError.divisionByZero
            }
            result = left / right
        default: fatalError("Unknown operator !")
        }
        calculation[currentIndex - 1] = "\(result)"
        calculation.remove(at: currentIndex)
        calculation.remove(at: currentIndex)
        return calculation
    }

    func calcul() throws {
        guard expressionIsCorrect && elements.count > 2 && !elements.contains("=") else {
            throw CalculationError.expressionIsNotCorrect
        }
        // Create local copy of operations
        var operationsToReduce = elements

        var indexMultiplication: Int? {
            return operationsToReduce.firstIndex(of: "x")
        }
        var indexDivision: Int? {
            return operationsToReduce.firstIndex(of: "/")
        }

        var indexDivisionOrMultiplication: Int? {
            if let indexMultiplication = indexMultiplication, let indexDivision = indexDivision {
                return indexMultiplication > indexDivision ? indexDivision  : indexMultiplication
            } else {
                return indexMultiplication ?? indexDivision
            }
        }

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {

            let index: Int = indexDivisionOrMultiplication ?? 1
            operationsToReduce = try priorityCalculation(operationsToReduce, currentIndex: index)
        }

        let intMax = Double(Int.max)
        var integerPart: Double = 0.0
        let float = modf(Double(operationsToReduce.first!)!, &integerPart)

        if float > 0.0 || integerPart > intMax { // operationsToReduce.first is a Double
            operation.append(" = \(operationsToReduce.first!)")
        } else { // operationsToReduce.first is an Int
            operation.append(" = \(Int(Double(operationsToReduce.first!)!))")
        }
    }

    func clearOperation() {
        operation = ""
    }
}
