//
//  Set+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 11/16/22.
//
//

import Foundation
import CoreData

extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var weight: Double
    @NSManaged public var reps: Int64
    @NSManaged public var rir: Double
    @NSManaged public var session: Session?
}

extension Set : Identifiable {

}
