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
    
    var markerTintColor: UIColor  {
        var toDate = Date()
        var daysAgo = 0
        daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        if daysAgo < 4 {
            return UIColor(named: "0-4 days") ?? UIColor.cyan
        } else {
            
            if daysAgo < 35 {
                return UIColor(named: "5-35 days") ?? UIColor.cyan
                
            } else {
                if daysAgo < 45 {
                    return UIColor(named: "36-45 days") ?? .red
                    
                } else {
                    if daysAgo < 55 {
                        return UIColor(named: "46-55 days") ?? .red
                    } else {
                        if daysAgo < 68 {
                            return UIColor(named: "56-68 days") ?? .red
                            
                        } else {
                            if daysAgo > 69 {
                                return UIColor(named: "69+ days") ?? UIColor.black
                            } 
                            
                        }
                        return UIColor(named: "Unknown") ?? .yellow
                    }
        }
        
//        if let interval = Calendar.current.dateComponents([.day], from: date, to: toDate).day, interval > 0 {
//            daysAgo = interval
//            print(interval)
//        }
        
      }
    }
    }


    init(
    title: String?,
    id: String?,
    coordinate: CLLocationCoordinate2D,
    date: Date
    ) {
        
    self.title = title
    self.id = id
    self.coordinate = coordinate
    self.date = date

    super.init()
    }


    
}
