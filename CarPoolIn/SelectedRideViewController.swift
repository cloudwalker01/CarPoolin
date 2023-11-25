//
//  SelectedRideViewController.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 24/11/23.
//

import UIKit
import MapKit

class SelectedRideViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var toFroLabel: UILabel!
    @IBOutlet var plateNumberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    var origin: String?
    var destination: String?
    var plateNumber: String?
    var name: String?
    var phoneNumber: String?
    var gender: String?
    
    private var originAnnotation: MKPointAnnotation?
    private var destinationAnnotation: MKPointAnnotation?
    private var locationManager = CLLocationManager()
    var isOrigin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toFroLabel.text = origin! + " → " + destination!
        plateNumberLabel.text = "Plate Number: " + plateNumber!
        nameLabel.text = "Name: " + name!
        phoneNumberLabel.text = "Phone Number: " + phoneNumber!
        genderLabel.text = "Gender: " + gender!
        
        mapView.mapType = .standard
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        // Create a dispatch group
        let dispatchGroup = DispatchGroup()

        // Enter the group before starting the first search
        dispatchGroup.enter()
        searchForLocation(origin!) { annotation in
            self.originAnnotation = annotation
            // Leave the group when the first search is complete
            dispatchGroup.leave()
        }

        // Enter the group before starting the second search
        dispatchGroup.enter()
        searchForLocation(destination!) { annotation in
            self.destinationAnnotation = annotation
            // Leave the group when the second search is complete
            dispatchGroup.leave()
        }

        // Notify when both searches are complete
        dispatchGroup.notify(queue: .main) {
            // Check if both annotations are available
            if let originAnnotation = self.originAnnotation, let destinationAnnotation = self.destinationAnnotation {
                // Call drawRoute with the obtained coordinates
                let originCoordinate = originAnnotation.coordinate
                let destinationCoordinate = destinationAnnotation.coordinate
                self.drawRoute(from: originCoordinate, to: destinationCoordinate)
            } else {
                // Handle the case where one or both annotations are nil
                print("Error: One or both annotations are nil.")
            }
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
    func searchForLocation(_ searchText: String, completion: @escaping (MKPointAnnotation?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Error searching for location: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            if let mapItem = response.mapItems.first {
                let annotation = self.displayLocationOnMap(mapItem)
                completion(annotation)
            } else {
                completion(nil)
            }
        }
    }
    
    func displayLocationOnMap(_ mapItem: MKMapItem) -> MKPointAnnotation {

        // Add a new annotation for the selected location
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name

        mapView.addAnnotation(annotation)

        // Optionally, zoom the map to the selected location
        let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        
        
        return annotation
    }
    
    func drawRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Create source and destination map items
        let sourcePlacemark = MKPlacemark(coordinate: origin, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)

        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)

        // Create a request with source and destination items
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = .automobile

        // Create a directions object
        let directions = MKDirections(request: request)

        // Calculate the route
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error calculating route: \(error.localizedDescription)")
                }
                return
            }

            // Get the first route from the response
            if let route = response.routes.first {
                // Add the route as an overlay on the map
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                // Set the visible region to include the route
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button tap, if needed
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    

     @IBAction func acceptPressed(_ sender: Any) {
         showAlert(title: "Ride Accepted", message: "Enjoy your Ride!")
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
