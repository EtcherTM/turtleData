//
//  NoActivityObservation.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/5/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import RealmSwift

 class NoActivityReport: Object {

    @objc dynamic var id : String = ""
    @objc dynamic var aNoActivity : Bool = false
    @objc dynamic var bNoActivity : Bool = false
    @objc dynamic var cNoActivity : Bool = false
    @objc dynamic var dNoActivity : Bool = false
    @objc dynamic var eNoActivity : Bool = false
    @objc dynamic var fNoActivity : Bool = false
    
    
//  What does this observation identifier look like:
    
//    [Zone]NAYYYYMMDD
// OR should this maybe be an array?

//
//    @objc dynamic var noActivityValue : String = ""

}
