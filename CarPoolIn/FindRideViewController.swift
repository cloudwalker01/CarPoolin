//
//  FindRideViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 22/11/23.
//

import UIKit
import MapKit


class DraggablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}


class FindRideViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var mapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var destinationSearchBar: UISearchBar!
    @IBOutlet var originSearchBar: UISearchBar!
    @IBOutlet var suggestionsTableView: UITableView!
    
    private var originAnnotation: MKPointAnnotation?
    private var destinationAnnotation: MKPointAnnotation?
    private var locationManager = CLLocationManager()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private var phoneNumber: String? = nil
    
    private var manager = DatabaseManager()
    
    var isOrigin: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let tabBarController = tabBarController as? DashboardTabBarController {
            phoneNumber = tabBarController.phoneNumber
        }
        
        mapView.mapType = .standard
        destinationSearchBar.delegate = self
        originSearchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set up search completer
        searchCompleter.delegate = self
        
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isHidden = true
        
        mapView.delegate = self
        
        mapView.mapType = .standard
        mapTypeSegmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()

        
        
       
        // Do any additional setup after loading the view.
    }
    @objc func mapTypeChanged() {
        switch mapTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is DraggablePin {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "draggablePin")
            pinView.isDraggable = true
            pinView.animatesDrop = true
            return pinView
        }
        return nil
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard

        if let searchText = searchBar.text, !searchText.isEmpty {
            searchForLocation(searchText)
        }
    }

    func searchForLocation(_ searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Error searching for location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let mapItem = response.mapItems.first {
                // Handle the first result (you can iterate through results if needed)
                self.displayLocationOnMap(mapItem)
            }
        }
    }

    func displayLocationOnMap(_ mapItem: MKMapItem) {

        // Add a new annotation for the selected location
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        
        if isOrigin 
        {
            if let tempAnnotation = originAnnotation {
                mapView.removeAnnotation(tempAnnotation)
            }
            originAnnotation = annotation
        }
        else
        {
            if let tempAnnotation = destinationAnnotation {
                mapView.removeAnnotation(tempAnnotation)
            }
            destinationAnnotation = annotation
        }

        mapView.addAnnotation(annotation)

        // Optionally, zoom the map to the selected location
        let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar {
        case originSearchBar:
            isOrigin = true
            if let tempAnnotation = originAnnotation {
                mapView.removeAnnotation(tempAnnotation)
            }
        case destinationSearchBar:
            isOrigin = false
            if let tempAnnotation = destinationAnnotation {
                mapView.removeAnnotation(tempAnnotation)
            }
        default:
            isOrigin = true
        }
        searchCompleter.queryFragment = searchText
        suggestionsTableView.isHidden = searchText.isEmpty
        mapView.isHidden = !searchText.isEmpty
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
           // Update your UI with search suggestions here
        suggestionsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
      
            
        cell.textLabel?.text = searchResults[indexPath.row].title
        cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
        return cell
    }

        // UITableViewDelegate method to handle selection of a suggestion
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = searchResults[indexPath.row]
            // Handle the selected suggestion, e.g., display it on the map
            // ...
        if isOrigin {
            originSearchBar.text = selectedSuggestion.title
            searchForLocation(selectedSuggestion.title)
        }
        else {
            destinationSearchBar.text = selectedSuggestion.title
            searchForLocation(selectedSuggestion.title)
        }
        
        suggestionsTableView.isHidden = true
        mapView.isHidden = false
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button tap, if needed
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitFindRidePressed(_ sender: Any) {
        guard let origin = originSearchBar.text, !origin.isEmpty else {
            // Put alert
            showAlert(title: "Invalid Details", message: "Enter Origin")
            return
        }
        
        guard let destination = destinationSearchBar.text, !destination.isEmpty else {
            // Put alert
            showAlert(title: "Invalid Details", message: "Enter Destination")
            return
        }
        
        let newFindRide = FindRide(origin: origin, destination: origin, phoneNumber: phoneNumber!)
        manager.addFindRide(newFindRide)
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
