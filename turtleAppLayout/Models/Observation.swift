//
//  observationType.swift
//  turtleAppLayout
//
//  Created by Olivia James on 8/27/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Observation: Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var date: Date = Date()
    
    @objc dynamic var zoneLocation: String = ""
    @objc dynamic var property: String = ""
    
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var accuracy: Double = 0.0
    
    @objc dynamic var nest : Bool = false
    @objc dynamic var turtle : Bool = false
    @objc dynamic var existingNestDisturbed : Bool = false
    
    @objc dynamic var nestType: String = ""
    @objc dynamic var turtleType: String = ""
    @objc dynamic var existingNestDisturbedType : String = ""

//    Moved hatching values into own Object
    @objc dynamic var hatchingBool = false
    @objc dynamic var hatchingDetails : Hatching?
    
    

//    @objc dynamic var docDirPath: String = ""

    @objc dynamic var image1: String = ""
    @objc dynamic var image2: String = ""
    @objc dynamic var image3: String = ""
    @objc dynamic var image4: String = ""
    @objc dynamic var image5: String = ""
    
    @objc dynamic var comments: String = ""
    


    
}
