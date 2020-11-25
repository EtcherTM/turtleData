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
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let db = Firestore.firestore()
    
    let realm = try! Realm()
    
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
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let points = self.realm.objects(MapPoint.self)
        print("no new")
        for point in points {
//            print(point.id)
            nestLocations.append(NestLocations(title: point.id, id: point.id, coordinate: CLLocationCoordinate2D(latitude: point.lat, longitude: point.lon), date: point.date, comments: point.comments))
        }
        
        doneGettingDocuments()
        
    }
    
    func doneGettingDocuments() {
        
        DispatchQueue.main.async {
            
//      Put sort so that maps newest first
            
            for n in self.nestLocations {
                //                print("addingdocuumentea")
                print("Placing point \(n.id) with coords \(n.coordinate)")
                self.mapView.addAnnotation(n)
            }
            
            
            
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
    
    @IBAction func updateMapButtonPressed(_ sender: UIBarButtonItem) {
        
        mapView.removeAnnotations(mapView.annotations)
        nestLocations = []
        db.collection("observations").whereField("type", arrayContainsAny: ["nest", "false nest"]).getDocuments() {(querySnapshot, error) in
            print("getting new stuff")
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                let points = self.realm.objects(MapPoint.self)
                
                do {
                    try self.realm.write{
                        self.realm.delete(points)
                    }
                } catch {
                    print(error)
                }
                
                for document in querySnapshot!.documents {
                    
                    let randomNumber = Double(Int.random(in: 0...5)) - 3 / 10000
                    let mapPoint = MapPoint()
                    
                    let data = document.data()
                    
                    if let type = document["type"] as? Array<String>, let active = document["active"] as? Bool {
                        
                        if (type.contains("nest") || type.contains("false nest")) && active {
                            
//                            if  document["date"] help need to only take those that are less than 71 days old
                            
                            
                            if let coords = document["coords"] {
                                let point = coords as! GeoPoint
                                let lat = point.latitude
                                let lon = point.longitude
                                
                                mapPoint.lat = lat + randomNumber
                                mapPoint.lon = lon
                                
                                
                                
                                //                    else if coords is empty, assign standard coordinates based on property
                                
                                let id = data["id"] as? String
                                let title = data["id"] as? String
                                let date = (data["date"] as? Timestamp ?? Timestamp()).dateValue()
                                
                                mapPoint.id = id ?? ""
                                mapPoint.date = date
                                
                                
                                let comments = data["comments"] as? String
                                mapPoint.comments = comments ?? ""
                                self.nestLocations.append(NestLocations(title: title, id: id, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude), date: date, comments: comments))
                                print("Mapping \(id) with coords: \(lat), \(lon)")
                                do {
                                    try self.realm.write {
                                        //print("mapPoint \(mapPoint)")
                                        self.realm.add(mapPoint)
                                    }
                                } catch {
                                    print("Error saving data, \(error) END")
                                }
                                
                            }
                        }
                    }
                }
            }
            
            print("done getting docs")
            
            self.doneGettingDocuments()
        }
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

