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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        existingRides = manager.fetchExistingRides()
        existingRidesTableView.reloadData()
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


