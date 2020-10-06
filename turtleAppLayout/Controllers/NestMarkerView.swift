//
//  nestMarkerViews.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/30/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import MapKit

class NestMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      // 1
    
      guard let nestLocation = newValue as? NestLocations else {

        return
      }
        
    
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)

      // 2
      markerTintColor = nestLocation.markerTintColor
        var daysAgo = 0
        daysAgo = Calendar.current.dateComponents([.day], from: nestLocation.date, to: Date()).day ?? 0
        if daysAgo >= 0 {
            glyphText = String(daysAgo)
        }
    }
  }
}
