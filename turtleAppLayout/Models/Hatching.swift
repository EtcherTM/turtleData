//
//  Hatching.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/12/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import Foundation
import RealmSwift

class Hatching: Object {

    @objc dynamic var hatchingExists : Bool = false // Not using this, probably can delete

    @objc dynamic var noProblems : Bool = false
    @objc dynamic var lights : Bool = false
    @objc dynamic var trash : Bool = false
    @objc dynamic var sewer : Bool = false
    @objc dynamic var plants : Bool = false
    @objc dynamic var other : Bool = false
    
    @objc dynamic var numSuccess = 0
    @objc dynamic var numStranded = 0
    @objc dynamic var numDead = 0
    
}

