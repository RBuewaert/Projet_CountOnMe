//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var calculation = Calculation()

    @IBOutlet weak var textView: UITextView!

    // View actions
    @IBAction func clearButton(_ sender: Any) {
        calculation.clearOperation()
        updateTextView()
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        calculation.addNumber(number: sender.title(for: .normal)!)
        updateTextView()
    }

    @IBAction func tappedPointButton(_ sender: Any) {
        do {
            try calculation.addPoint()
            updateTextView()
        } catch {
            errorMessage(message: "Enter a correct expression !")
        }
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        let buttonlabel = sender.title(for: .normal) ?? ""
        guard let operatorType = OperatorType(rawValue: buttonlabel) else {
            return print("Unknown operator")
        }

        do {
            try calculation.addOperator(operatorType: operatorType)
            updateTextView()
        } catch {
            errorMessage(message: "An operator is already present !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        do {
            try calculation.calcul()
            updateTextView()
        } catch CalculationError.divisionByZero {
            errorMessage(message: "It is not possible to divide by zero")
        } catch {
            errorMessage(message: "Enter a correct expression !")
        }
    }

    private func updateTextView() {
        textView.text = calculation.operation
        let range = NSRange(location: textView.text.count - 1, length: 0)
        textView.scrollRangeToVisible(range)
    }

    private func errorMessage(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
