/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class TipCalculatorViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var billAmountTextField: UITextField!
  @IBOutlet weak var tipPercentLabel: UILabel!
  @IBOutlet weak var tipAmountLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  
  // MARK: - Properties
  
  // Whenever this value changes, the view will be updated
  // due to the didSet() property observer
  private var currentTipPercent: Double = 0.15 {
    didSet {
      updateViews()
    }
  }
  
  // Whenever this value changes, the view will be updated
  // due to the didSet() property observer
  private var currentBillAmount: Double? {
    didSet {
      updateViews()
    }
  }
  
  // MARK: - IBActions
  
  @IBAction func stepperTapped(_ sender: UIStepper) {
    currentTipPercent = sender.value
  }
  
  // MARK: - Private Methods
  
  private func updateViews() {
    // Update tip percent label
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .percent
    let percentString = numberFormatter.string(from: NSNumber(value: currentTipPercent)) ?? "0%"
    tipPercentLabel.text = "\(percentString) Tip"
    
    // Calculate tip and total
    if let billAmount = currentBillAmount {
      numberFormatter.numberStyle = .currency
      
      // Calculate tip amount and update tip amount label
      let tipAmount = billAmount * currentTipPercent
      tipAmountLabel.text = numberFormatter.string(from: NSNumber(value: tipAmount)) ?? "$0.00"
      
      // Calculate total bill and update total label
      let total = billAmount + tipAmount
      totalLabel.text = numberFormatter.string(from: NSNumber(value: total)) ?? "$0.00"
      
      // Format the bill amount to appear as currency
      billAmountTextField.text = numberFormatter.string(from: NSNumber(value: billAmount)) ?? "$0.00"
    } else {
      // Clear out the tipAmountLabel and totalLabel if the billAmount value doesn’t exist.
      tipAmountLabel.text = ""
      totalLabel.text = ""
    }
  }
  
  /// This method is mainly for convenience to show errors during validation of the bill amount.
  /// It provides an easy way to inform the user of issue through an alert controller.
  private func showAlert(for title: String, stating message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
}

/// This class conforms to the `UITextFieldDelegate`, which provides notifications
/// when the user either begins to edit the `billAmount` field, or when they tap
/// the return key on the keyboard.
extension TipCalculatorViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // If the text is not nil, and also not empty,
    // proceed to process the data from it.
    if let text = textField.text,
      !text.isEmpty {
      // The data collected must actually be a number (specifically a Double).
      if let billAmount = Double(text) {
        currentBillAmount = billAmount
        // Resigning first responder status will cause the keyboard to hide.
        textField.resignFirstResponder()
      } else {
        showAlert(for: "Invalid Amount", stating: "Please enter a bill amount in dollars and cents.")
        textField.text = ""
      }
    } else {
      showAlert(for: "No Amount Entered", stating: "Please enter a bill amount.")
    }
    
    // Returning false tells the textfield not to implement its default behavior.
    return false
  }
  
  /// Whenever the user taps on the textfield to begin entering a bill amount,
  /// this method will clear the tip amount and total fields since they might have
  /// been showing values for the previous bill amount.
  func textFieldDidBeginEditing(_ textField: UITextField) {
    tipAmountLabel.text = "$0.00"
    totalLabel.text = "$0.00"
  }
}

