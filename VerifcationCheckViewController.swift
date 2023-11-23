//
//  VerifcationCheckViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import UIKit

class VerifcationCheckViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var codeField1: UITextField!
    @IBOutlet var codeField2: UITextField!
    @IBOutlet var codeField3: UITextField!
    @IBOutlet var codeField4: UITextField!
    @IBOutlet var codeField5: UITextField!
    @IBOutlet var codeField6: UITextField!
    @IBOutlet var errorLabel: UILabel! = UILabel()
    
    
       
    var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    private var manager = DatabaseManager()
    
    var mobNo: String {
        countryCode! + phoneNumber!
    }
    
    init?(coder: NSCoder, countryCode: String, phoneNumber: String) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func validateCode()
    {
        self.errorLabel.text = nil // reset
        
        if let code1 = codeField1.text, let code2 = codeField2.text, let code3 = codeField3.text, let code4 = codeField4.text, let code5 = codeField5.text, let code6 = codeField6.text  {
            let code = code1 + code2 + code3 + code4 + code5 + code6
            VerifyAPI.validateVerificationCode(self.countryCode!, self.phoneNumber!, code)
            { checked in
                if (checked.success)
                {
                    self.resultMessage = checked.message
                    if !self.manager.doesUserExist(phoneNumber: self.mobNo) {
                        self.performSegue(withIdentifier: "ShowSignUp", sender: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "ShowDashboard", sender: nil)
                    }
                }
                else
                {
                    self.errorLabel.text = "Invalid OTP. Please try again."
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Check if the length of the entered text is 1 (a single digit)
            if (textField.text?.count ?? 0) == 1 {
                // Move to the next text field
                switch textField {
                case codeField1:
                    codeField2.becomeFirstResponder()
                case codeField2:
                    codeField3.becomeFirstResponder()
                case codeField3:
                    codeField4.becomeFirstResponder()
                case codeField4:
                    codeField5.becomeFirstResponder()
                case codeField5:
                    codeField6.becomeFirstResponder()
                    // Move to the next text field or handle accordingly
                    // Example: textField3.becomeFirstResponder()
                // Add cases for the remaining text fields
                default:
                    break
                }
            }

            // Allow the character change
            return true
        }

       
    @IBAction func clearPressed(_ sender: Any) {
        codeField1.text = ""
        codeField2.text = ""
        codeField3.text = ""
        codeField4.text = ""
        codeField5.text = ""
        codeField6.text = ""
        codeField1.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeField1.delegate = self
        codeField2.delegate = self
        codeField3.delegate = self
        codeField4.delegate = self
        codeField5.delegate = self
        codeField6.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBSegueAction func showSignUp(_ coder: NSCoder) -> SignUpViewController? {
        
        return SignUpViewController(coder: coder, phoneNumber: mobNo)
    }
    
     @IBSegueAction func showDashboard(_ coder: NSCoder) -> DashboardTabBarController? {
         let newTabBar = DashboardTabBarController(coder: coder)
         newTabBar?.phoneNumber = mobNo
         return newTabBar
     }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
