//
//  SignUpViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var agePicker: UIPickerView!
    @IBOutlet var genderPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        agePicker.dataSource = self
        agePicker.delegate = self

        genderPicker.dataSource = self
        genderPicker.delegate = self
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agePicker {
            return 100 // 1 to 100 ages
        } else if pickerView == genderPicker {
            return 3 // Male, Female, Other
        }
        return 0
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agePicker {
            return "\(row + 1)"
        } else if pickerView == genderPicker {
            switch row {
            case 0:
                return "Male"
            case 1:
                return "Female"
            case 2:
                return "Other"
            default:
                return nil
            }
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == agePicker {
            // Handle selected age
            let selectedAge = row + 1
            print("Selected Age: \(selectedAge)")
        } else if pickerView == genderPicker {
            // Handle selected gender
            let selectedGender: String
            switch row {
            case 0:
                selectedGender = "Male"
            case 1:
                selectedGender = "Female"
            case 2:
                selectedGender = "Other"
            default:
                return
            }
            print("Selected Gender: \(selectedGender)")
        }
    }
}
