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
    var zoneLoc = "X"
    
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
        
//        var points = [CLLocationCoordinate2D] ()
//        points.append(CLLocationCoordinate2DMake(0.44047, 9.41562))
//        points.append(CLLocationCoordinate2DMake(0.44038, 9.41523))
//        points.append(CLLocationCoordinate2DMake(0.43628, 9.41618))
//        points.append(CLLocationCoordinate2DMake(0.43618, 9.41684))
//
//        let polygon = MKPolygon(coordinates: points, count: 4)
//        mapView.addOverlay(polygon)
//        polygonRenderer.lineWidth = 5

        
        
        
//        let dateString = "01/20/2020"
//        let dateFormatter = DateFormatter()
//       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        if let date = dateFormatter.date(from: dateString) {
//            print(date)
//        }
 
//MARK:- Download map points
        db.collection("observations").getDocuments() {(querySnapshot, error) in

                if let error = error {

                    print("Error getting documents: \(error.localizedDescription)")

                } else {

                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if (data["type"] as? [String: Any])?["nest"] as? String == "nest" {
                        
                    let zoneLoc = data["zone"] as? String
                    
                    let coords = data["coords"] as? Array<Double>

                    let id = data["imageURLS"] as? String

                    let date = (data["date"] as? Timestamp ?? Timestamp()).dateValue()
                    
                    print(date)

                    if let coords = coords {

                    self.nestLocations.append(NestLocations(title: id, id: id, coordinate: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]), date: date))

                    }
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

