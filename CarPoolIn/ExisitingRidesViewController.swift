//
//  ExisitingRidesViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 24/11/23.
//

import UIKit

class ExisitingRidesViewController: UIViewController {
    
    @IBOutlet var existingRidesTableView: UITableView!
    
    private var existingRides: [OfferRideEntity] = []
    private let manager = DatabaseManager()
    
    var userPhoneNumber: String? = nil
    var desiredOrigin: String?
    var desiredDestination: String?
    
    var selectedRide: OfferRideEntity = OfferRideEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        existingRidesTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let desiredOrigin = desiredOrigin, let desiredDestination = desiredDestination {
            existingRides = manager.fetchFilteredRide(origin: desiredOrigin, destination: desiredDestination)
        }
        else {
            existingRides = manager.fetchExistingRides()
            
        }
        existingRidesTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExistingToSelected" {
            // Make sure to replace "YourSegueIdentifier" with the actual identifier of your segue

            if let selectedRideViewController = segue.destination as? SelectedRideViewController {
                // Pass the data to the destination view controller
                selectedRideViewController.origin = selectedRide.origin!
                selectedRideViewController.destination = selectedRide.destination!
                selectedRideViewController.plateNumber = selectedRide.plateNumber!
                selectedRideViewController.phoneNumber = selectedRide.phoneNumber!
                
                let selectedUser = manager.fetchUser(phoneNumber: selectedRide.phoneNumber!)
                
                selectedRideViewController.name = (selectedUser?.firstName)! + " " + (selectedUser?.lastName)!
                selectedRideViewController.gender = selectedUser?.sex!
            }
        }
    }
}
extension ExisitingRidesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected ride
        self.selectedRide = existingRides[indexPath.row]


        performSegue(withIdentifier: "ExistingToSelected", sender: nil)
    }
}

extension ExisitingRidesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        existingRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        let existingRide = existingRides[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = (existingRide.origin!) + " to " + (existingRide.destination!)
        if let storedDate = existingRide.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a" // You can customize the format based on your needs
            
            let formattedDate = dateFormatter.string(from: storedDate)
            content.secondaryText = formattedDate
        }
//        content.SecondaryText = "Plate Number: " + existingRide.plateNumber!
        
        
        cell.contentConfiguration = content
        return cell
    }
}
    
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


