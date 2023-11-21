//
//  LoginViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 20/11/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Replace the baseURLString with your local server address
    private static let baseURLString = "http://127.0.0.1:5000"
       
    @IBOutlet var countryCodeField: UILabel! = UILabel()
    @IBOutlet var phoneNumberField: UITextField! = UITextField()
        
    @IBAction func sendVerification() 
    {
        if let phoneNumber = phoneNumberField.text, let countryCode = countryCodeField.text
        {
            LoginViewController.sendVerificationCode(countryCode, phoneNumber)
            performSegue(withIdentifier: "VerificationCheck", sender: self)
        }
        
    }
        
    @IBSegueAction func showVerificationView(_ coder: NSCoder) -> VerifcationCheckViewController? {
        return VerifcationCheckViewController(coder: coder, countryCode: "+91", phoneNumber: phoneNumberField.text!)
    }
    static func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) 
    {
        let parameters = [
            "via": "sms",
            "country_code": countryCode,
            "phone_number": phoneNumber
        ]
    
        let path = "start"
        let method = "POST"
        
        let urlPath = "\(baseURLString)/\(path)"
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters 
        {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
    
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let session: URLSession = 
        {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            if let data = data
            {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data,options: []) as? [String : Any]
                    print(jsonSerialized!)
                }  
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
            } 
            else if let error = error
            {
                print(error.localizedDescription)
            }
        }
        task.resume()
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
