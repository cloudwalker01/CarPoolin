//
//  VerifcationCheckViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import UIKit

class VerifcationCheckViewController: UIViewController {
    

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
                    self.performSegue(withIdentifier: "ShowSignUp", sender: nil)
                }
                else
                {
                    self.errorLabel.text = "Invalid OTP. Please try again."
                }
            }
        }
    }
       

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
