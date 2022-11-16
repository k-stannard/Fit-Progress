//
//  Session+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 11/16/22.
//
//

import Foundation
import CoreData

extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var date: Date?
    @NSManaged public var exercise: Exercise?
    @NSManaged public var sets: NSOrderedSet?
}

// MARK: Generated accessors for sets
extension Session {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: Set, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [Set], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: Set)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [Set])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: Set)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: Set)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

extension Session : Identifiable {

}
