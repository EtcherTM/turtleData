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
        
//        let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)

        
        
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
        
        /*
        let nestLocations = [
            NestLocations (title: "A-N-20200929-user",
                           id: "A-N-20200929-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.437601, longitude: 9.416195),
                           date: formatter.date(from: "09/29/2020") ?? Date()),
                             
            NestLocations (title: "G-T-20200807-user",
                           id: "G-T-20200807-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.461894, longitude: 9.404853),
                           date: formatter.date(from: "08/07/2020") ?? Date()),

            NestLocations (title: "D-N-20200926-user",
                           id: "D-N-20200926-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.448704, longitude: 9.414098),
                           date: formatter.date(from: "08/30/2020") ?? Date()),

            NestLocations (title: "C-N-20200820-user",
                           id: "C-N-20200820-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.444734, longitude: 9.414095),
                           date: formatter.date(from: "08/20/2020") ?? Date()),
        
            NestLocations (title: "E-F-20200730-user",
                           id: "E-F-20200730-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.457181, longitude:  9.407347),
                           date: formatter.date(from: "07/30/2020") ?? Date()),
            
            NestLocations (title: "B-N-20200710-user",
                           id: "B-N-20200710-user",
                           coordinate: CLLocationCoordinate2D(latitude: 0.440590, longitude:  9.415476),
                           date: formatter.date(from: "07/10/2020") ?? Date()),

            
        ]*/
        self.dispatchGroup.enter()

//        Below sign in does not change anything:
//        Auth.auth().signInAnonymously { (result, error) in
//            print("result:\(result) " )
//            print("error: \(error)")
//        }
        
        let db = Firestore.firestore()
        db.collection("observations").getDocuments { (querySnapshot, error) in
            if let error = error {
                
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                
                for document in querySnapshot!.documents {
                    let data = document.data()
      
                    
                    let coords = data["coords"] as? Array<Double>
              
                    let id = data["imageURLS"] as? String
                    let date = data["date"] as? Date
                    
                    if let coords = coords {
                        
                            self.nestLocations.append(NestLocations(title: id, id: id, coordinate: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]), date: date ?? Date()))
                        
                    }
                }
                
            }
            
            self.dispatchGroup.leave()

            print("done getting docs")
            
        }
        
        
       
        
        self.dispatchGroup.wait()
        
        DispatchQueue.main.async {
            print(self.nestLocations)
            for n in self.nestLocations {
                       print(n)
                self.mapView.addAnnotation(n)
                   }

        }
        
       
        
        
        
        
    }
    
    @IBAction func mapTypeSegmentSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
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
  // 1
//  func mapView(
//    _ mapView: MKMapView,
//    viewFor annotation: MKAnnotation
//  ) -> MKAnnotationView? {
//    // 2
//    guard let annotation = annotation as? NestLocations else {
//      return nil
//    }
//    // 3
//    let identifier = "nestLocation"
//    var view: MKMarkerAnnotationView
//    // 4
//    if let dequeuedView = mapView.dequeueReusableAnnotationView(
//        withIdentifier: identifier) as? MKMarkerAnnotationView {
//      dequeuedView.annotation = annotation
//      view = dequeuedView
//    } else {
//      // 5
//      view = MKMarkerAnnotationView(
//        annotation: annotation,
//        reuseIdentifier: identifier)
//      view.canShowCallout = true
//      view.calloutOffset = CGPoint(x: -5, y: 5)
//      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//    }
//    return view
//  }
}

