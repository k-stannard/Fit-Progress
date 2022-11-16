//
//  Exercise+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 11/16/22.
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
    @NSManaged public var session: NSSet?
    @NSManaged public var workout: Workout?
}

// MARK: Generated accessors for session
extension Exercise {

    @objc(addSessionObject:)
    @NSManaged public func addToSession(_ value: Session)

    @objc(removeSessionObject:)
    @NSManaged public func removeFromSession(_ value: Session)

    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSSet)

    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSSet)

}

extension Exercise : Identifiable {

}
