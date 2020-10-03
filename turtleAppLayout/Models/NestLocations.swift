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
        print("made it to markertintcolor")
        var daysAgo = 0
        daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        if daysAgo < 5 {
            return UIColor(named: "0-4 days") ?? UIColor.cyan
        } else {
            
            if daysAgo < 36 {
                return UIColor(named: "5-35 days") ?? UIColor.cyan
                
            } else {
                if daysAgo < 46 {
                    return UIColor(named: "36-45 days") ?? .red
                    
                } else {
                    if daysAgo < 61 {
                        return UIColor(named: "46-60 days") ?? .red
                    } else {
                        if daysAgo < 71 {
                            return UIColor(named: "61-70 days") ?? .red
                            
                        } else {
                            if daysAgo > 72 {
                                return UIColor(named: "71+ days") ?? .white
                            } 
                            
                        }
                        return UIColor(named: "Unknown") ?? .yellow
                    }
        }
    
        
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
