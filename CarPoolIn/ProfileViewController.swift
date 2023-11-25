//
//  ProfileViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 22/11/23.
//

import UIKit

class ProfileViewController: UIViewController {

    private var phoneNumber: String? = nil
    
    let manager = DatabaseManager()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBarController = tabBarController as? DashboardTabBarController {
            phoneNumber = tabBarController.phoneNumber
        }
        
        if let phoneNumber = phoneNumber {
            let currentUser = manager.fetchUser(phoneNumber: phoneNumber)
            
            updateUI(user: currentUser!)
        }
    }
    
    func updateUI(user: UserEntity) {
        nameLabel.text = "Name: " + user.firstName! + " " + user.lastName!
        phoneNumberLabel.text = "Phone Number: " + user.mobNo!
        emailLabel.text = "E-mail ID: " + user.email!
        ageLabel.text = "Age: " + String(user.age)
        sexLabel.text = "Sex: " + user.sex!
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        performSegue(withIdentifier: "LoggedOut", sender: nil)
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
