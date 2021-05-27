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

    var errorMessage = ""

    func testGivenOperationIsEmpty_WhenUserTape1Number_ThenNumberAddOnOperation() {
        calculation.operation = ""

        calculation.addNumber(number: "3")

        XCTAssertEqual(calculation.operation, "3")
    }

    func testGivenOperationContainNumber_WhenUserTapeOneNumber_ThenNumberAddOnOperation() {
        calculation.operation = "32"

        calculation.addNumber(number: "5")

        XCTAssertEqual(calculation.operation, "325")
    }

    func testGivenOperationHaveResult_WhenUserTapeOneNumber_ThenOperationIsResetedAndNumberAddOnOperation() {
        calculation.operation = "2 + 4 = 6"

        calculation.addNumber(number: "5")

        XCTAssertEqual(calculation.operation, "5")
    }

    func testGivenResult_WhenUserTapeAnOperator_ThenOperatorIsAddedToResult() {
        calculation.operation = "3 + 2 = 5"

        do {
            try calculation.addOperator(operatorType: .addition)
        } catch {
            errorMessage = "An operator is already present !"
        }

        XCTAssertEqual(calculation.operation, "5 + ")
    }

    func testGivenOperationIsEmpty_WhenUserTapeOneOperator_ThenOperatorNotAddedToOperation() {
        calculation.operation = ""

        do {
            try calculation.addOperator(operatorType: .addition)
        } catch {
            errorMessage = "An operator is already present !"
        }

        XCTAssertEqual(calculation.operation, "")
        XCTAssertEqual(errorMessage, "An operator is already present !")
    }

    func testGivenOperationIsNotEmpty_WhenUserTapeOneOperator_ThenOperatorAddedToOperation() {
        calculation.operation = "41"

        do {
            try calculation.addOperator(operatorType: .substraction)
        } catch {
            errorMessage = "An operator is already present !"
        }

        XCTAssertEqual(calculation.operation, "41 - ")
    }

    func testGivenOperationSimpleAddition_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "3 + 2"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "3 + 2 = 5")
    }

    func testGivenOperationSimpleMultiplication_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "3 x 2.5"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "3 x 2.5 = 7.5")
    }

    func testGivenOperationContainDivisionAndMultiplication_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "12 / 3 x 2"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "12 / 3 x 2 = 8")
    }

    func testGivenOperationIsComplexe_WhenUserTapeEqual_ThenOperatorDisplayResult() {
        calculation.operation = "3 + 2 x 2 - 10 / 2"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "3 + 2 x 2 - 10 / 2 = 2")
    }

    func testGivenOperationIsIncorrect_WhenUserTapeEqual_ThenOperatorNotDisplayResultAndAnErrorMessageIsDisplay() {
        calculation.operation = "2 x"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "2 x")
        XCTAssertEqual(errorMessage, "Enter a correct expression !")
    }

    func testGivenOperationIsNotEmpty_WhenUserTapeCButton_ThenCurrentOperationIsRemoved() {
        calculation.operation = "3 + 5"

        calculation.clearOperation()

        XCTAssertEqual(calculation.operation, "")
    }

    func testGivenOperationIsDivisedByZero_WhenUserTapeEqualButton_ThenTheResultIsNotDisplay() {
        calculation.operation = "3 / 0"

        do {
            try calculation.calcul()
        } catch CalculationError.divisionByZero {
            errorMessage = "It is not possible to divide by zero !"
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "3 / 0")
        XCTAssertEqual(errorMessage, "It is not possible to divide by zero !")
    }

    func testGivenOperationNoContainPoint_WhenUserTapeOnePoint_ThenPointAddedToOperation() {
        calculation.operation = "4"

        do {
            try calculation.addPoint()
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "4.")
    }

    func testGivenOperationContainPoint_WhenUserTapeOnePoint_ThenPointNotAddedToOperation() {
        calculation.operation = "4.2"

        do {
            try calculation.addPoint()
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, "4.2")
        XCTAssertEqual(errorMessage, "Enter a correct expression !")
    }

    func testGivenOperationHaveResult_WhenUserTapeOnePoint_ThenOperationResetedAndPointAdded() {
        calculation.operation = "3 + 2 = 5"

        do {
            try calculation.addPoint()
        } catch {
            errorMessage = "Enter a correct expression !"
        }

        XCTAssertEqual(calculation.operation, ".")
    }
}
