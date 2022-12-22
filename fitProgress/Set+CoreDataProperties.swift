//
//  Set+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 11/19/22.
//
//

import Foundation
import CoreData

extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var reps: Int64
    @NSManaged public var rir: Double
    @NSManaged public var weight: Double
    @NSManaged public var sessionDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var exercise: Exercise?
}

extension Set : Identifiable {

}
