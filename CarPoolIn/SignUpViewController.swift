//
//  SignUpViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var agePicker: UIPickerView!
    @IBOutlet var genderPicker: UIPickerView!
    
    let phoneNumber:String
    var selectedGender: String = ""
    var selectedAge: Int = 1
    
    private let manager = DatabaseManager()
    
    init?(coder:NSCoder,phoneNumber:String) {
        self.phoneNumber = phoneNumber
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) 
    {
        if pickerView == agePicker 
        {
            // Handle selected age
            let selectedAge = row + 1
            self.selectedAge = selectedAge
            print("Selected Age: \(selectedAge)")
        } 
        else if pickerView == genderPicker
        {
            // Handle selected gender
            let selectedGender: String
            switch row 
            {
            case 0:
                selectedGender = "Male"
            case 1:
                selectedGender = "Female"
            case 2:
                selectedGender = "Other"
            default:
                return
            }
            self.selectedGender = selectedGender
            print("Selected Gender: \(selectedGender)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button tap, if needed
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        guard let firstName = firstName.text, !firstName.isEmpty else {
            // Put alert
            showAlert(title: "Invalid Details", message: "Enter First Name")
            return
        }
        
        guard let lastName = lastName.text, !lastName.isEmpty else {
            // Put alert
            showAlert(title: "Invalid Details", message: "Enter Last Name")
            return
        }
        
        guard let email = email.text, !email.isEmpty else {
            // Put alert
            showAlert(title: "Invalid Details", message: "Enter E-mail ID")
            return
        }
        
        let newUser = User(firstName: firstName, lastName: lastName, email: email, sex: selectedGender, phoneNumber: phoneNumber, age: Int64(selectedAge))
        
        manager.addUser(newUser)
        
        performSegue(withIdentifier: "SignupToDashboard", sender: nil)
    }
    

  
}
