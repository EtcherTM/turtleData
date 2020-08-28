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
    @objc dynamic var zoneLocation: String = ""
    @objc dynamic var property: String = ""
    @objc dynamic var nest : Bool = false
    @objc dynamic var track : Bool = false
    @objc dynamic var turtle : Bool = false
    @objc dynamic var eggs : Bool = false
    @objc dynamic var carcass : Bool = false
    
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    @objc dynamic var date: Date = Date()
}
