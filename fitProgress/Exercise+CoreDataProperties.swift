//
//  Exercise+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 10/25/22.
//
//

import Foundation
import CoreData

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var reps: [Int]?
    @NSManaged public var sets: [Int]?
    @NSManaged public var workout: Workout?
    @NSManaged public var weight: NSSet?

}

// MARK: Generated accessors for weight
extension Exercise {

    @objc(addWeightObject:)
    @NSManaged public func addToWeight(_ value: Weight)

    @objc(removeWeightObject:)
    @NSManaged public func removeFromWeight(_ value: Weight)

    @objc(addWeight:)
    @NSManaged public func addToWeight(_ values: NSSet)

    @objc(removeWeight:)
    @NSManaged public func removeFromWeight(_ values: NSSet)

}

extension Exercise : Identifiable {

}
