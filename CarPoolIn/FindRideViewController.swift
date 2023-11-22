//
//  FindRideViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 22/11/23.
//

import UIKit
import MapKit

class FindRideViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var suggestionsTableView: UITableView!
    private var locationManager = CLLocationManager()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Set up search completer
        searchCompleter.delegate = self
        
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isHidden = true
        // Do any additional setup after loading the view.
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
        // Clear previous annotations on the map
        mapView.removeAnnotations(mapView.annotations)

        // Add a new annotation for the selected location
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name

        mapView.addAnnotation(annotation)

        // Optionally, zoom the map to the selected location
        let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        searchBar.text = selectedSuggestion.title // Optionally, update the search bar with the selected suggestion
        suggestionsTableView.isHidden = true
        mapView.isHidden = false
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
