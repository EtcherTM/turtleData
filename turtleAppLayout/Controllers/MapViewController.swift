//
//  MapViewController.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/29/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let dispatchGroup = DispatchGroup()
    let db = Firestore.firestore()

    
    @IBOutlet private var mapView: MKMapView!

    var locationManager = CLLocationManager()
    var userLocated = false
    
    var nestLocations: Array<NestLocations> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
                
        } else {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true

        }

        
        let initialLocation = CLLocation(latitude: 0.458049, longitude: 9.406771)
        mapView.centerToLocation(initialLocation)
        let plageTahitiCenter = CLLocation(latitude: 0.458049, longitude: 9.406771)
  
        let region = MKCoordinateRegion(
            center: plageTahitiCenter.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 10000)

        mapView.setRegion(mapView.regionThatFits(region), animated: true)

        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        mapView.delegate = self
        
        mapView.register(NestMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
//        let dateString = "01/20/2020"
//        let dateFormatter = DateFormatter()
//       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        if let date = dateFormatter.date(from: dateString) {
//            print(date)
//        }
 
//MARK:- Download map points

        db.collection("observations").getDocuments { (querySnapshot, error) in
            if let error = error {

                print("Error getting documents: \(error.localizedDescription)")
            } else {

                for document in querySnapshot!.documents {

                    let data = document.data()

                    let coords = data["coords"] as? Array<Double>

                    let id = data["imageURLS"] as? String

                    let timestamp: Timestamp
                    timestamp = data["date"] as! Timestamp

                    let date: Date = timestamp.dateValue()
                    print(date)

                    if let coords = coords {

                    self.nestLocations.append(NestLocations(title: id, id: id, coordinate: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]), date: date ?? Date()))

                    }
                }
            }

            print("done getting docs")

            self.doneGettingDocuments()
        }
//        mapView.addAnnotation(nestLocations)

        
    }
    func doneGettingDocuments() {
        DispatchQueue.main.async {
            for n in self.nestLocations {
                print(self.nestLocations)
            self.mapView.addAnnotation(n)
            }
            print(self.nestLocations)
            

            
        }
    }
    @IBAction func mapTypeSegmentSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .satellite
        }
    }
    
    
    @IBAction func centerToUserButtonPressed(_ sender: UIBarButtonItem) {
            centerToUsersLocation()
    }
    
    func centerToUsersLocation() {
      let center = mapView.userLocation.coordinate
      let zoomRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
      
      mapView.setRegion(zoomRegion, animated: true)
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

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension MapViewController: MKMapViewDelegate {

}

