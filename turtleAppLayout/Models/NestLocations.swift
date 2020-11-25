//
//  NestLocations.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/30/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import MapKit

class NestLocations: NSObject, MKAnnotation {
    let title: String?
    let id: String?
    let coordinate: CLLocationCoordinate2D
    let date: Date
    let comments: String?
    
    var markerTintColor: UIColor  {
        var daysAgo = 0
        daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        switch daysAgo {
        case 0...4:
            return UIColor(named: "0-4 days") ?? UIColor.cyan
        case 5...36:
            return UIColor(named: "5-35 days") ?? UIColor.cyan
        case 37...45:
            return UIColor(named: "36-45 days") ?? .red
        case 46...60:
            return UIColor(named: "46-60 days") ?? .red
        case 61...70:
            return UIColor(named: "61-70 days") ?? .red
        default:
            return UIColor(named: "71+ days") ?? .white
        }
    }
    
    
    init(
        title: String?,
        id: String?,
        coordinate: CLLocationCoordinate2D,
        date: Date,
        comments: String?
    ) {
        
        self.title = title
        self.id = id
        self.coordinate = coordinate
        self.date = date
        self.comments = comments
        
        
        super.init()
    }
    
    
    
}
