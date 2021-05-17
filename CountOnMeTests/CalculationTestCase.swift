//
//  CalculationTestCase.swift
//  CountOnMeTests
//
//  Created by Romain Buewaert on 12/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculationTestCase: XCTestCase {
    var calculation: Calculation!

    override func setUp() {
        super.setUp()
        calculation = Calculation()
    }

    func errorMessage() {
        print("Un operateur est déja mis !")
    }

    func expressionIsNotCorrect() {
        print("Entrez une expression correcte !")
    }

    func testGivenOperationIsEmpty_WhenUserTape1Number_ThenNumberAddOnOperation() {
        calculation.operation = ""

        calculation.addNumber(number: "3")

        XCTAssertEqual(calculation.operation, "3")
    }

    func testGivenOperationIsNotEmpty_WhenUserTape1Number_ThenNumberAddOnOperation() {
        calculation.operation = "32"

        calculation.addNumber(number: "5")

        XCTAssertEqual(calculation.operation, "325")
    }

    func testGivenOperationHaveResult_WhenUserTape1Number_ThenOperationIsResetedAndNumberAddOnOperation() {
        calculation.operation = "2 + 4 = 6"

        calculation.addNumber(number: "5")

        XCTAssertEqual(calculation.operation, "5")
    }

    func testGivenOperationIsEmpty_WhenUserTape1OperatorForAddition_ThenOperatorNotAddedToOperation() {
        calculation.operation = ""

        calculation.addOperator(operatorType: .addition, errorMessage: errorMessage)

        XCTAssertEqual(calculation.operation, "")
    }

    func testGivenOperationIsNotEmpty_WhenUserTape1OperatorForSubstraction_ThenOperatorAddedToOperation() {
        calculation.operation = "41"

        calculation.addOperator(operatorType: .substraction, errorMessage: errorMessage)

        XCTAssertEqual(calculation.operation, "41 - ")
    }

    func testGivenOperationIsSimple_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "3 + 2"

        calculation.calcul(expressionIsNotCorrect: expressionIsNotCorrect)

        XCTAssertEqual(calculation.operation, "3 + 2 = 5")
    }

    func testGivenOperationIsComplexe_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "3 + 2 x 2 - 10 / 2"

        calculation.calcul(expressionIsNotCorrect: expressionIsNotCorrect)

        XCTAssertEqual(calculation.operation, "3 + 2 x 2 - 10 / 2 = 2")
    }
}
