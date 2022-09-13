//
//  Exercise+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/26/22.
//
//

import Foundation
import CoreData

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var workout: String
    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var weight: [String]?
    @NSManaged public var sets: [String]?
    @NSManaged public var reps: [String]?
}

extension Exercise : Identifiable {

}
