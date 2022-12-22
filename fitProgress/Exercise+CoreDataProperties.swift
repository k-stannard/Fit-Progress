//
//  Exercise+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 11/19/22.
//
//

import Foundation
import CoreData

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var workout: Workout?
    @NSManaged public var sets: Set?

}

extension Exercise : Identifiable {

}
