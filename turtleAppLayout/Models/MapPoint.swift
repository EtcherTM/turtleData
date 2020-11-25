//
//  MapPoint.swift
//  turtleAppLayout
//
//  Created by Olivia James on 10/11/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class MapPoint: Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var date: Date = Date()
    
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var accuracy: Double = 0.0
    @objc dynamic var comments: String = ""
    
}
