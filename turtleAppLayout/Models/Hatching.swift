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

    @objc dynamic var hatching : Bool = false
    @objc dynamic var hatchingNoProblems : Bool = false

    @objc dynamic var hatchingLights : Bool = false
    @objc dynamic var hatchingTrash : Bool = false
    @objc dynamic var hatchingSewer : Bool = false
    @objc dynamic var hatchingPlants : Bool = false
    @objc dynamic var hatchingOther : Bool = false
    
   @objc dynamic var numSuccess = 0
    @objc dynamic var numStranded = 0
    @objc dynamic var numDead = 0
    
}

