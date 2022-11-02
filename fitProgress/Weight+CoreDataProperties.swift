//
//  Weight+CoreDataProperties.swift
//  fitProgress
//
//  Created by Koty Stannard on 10/25/22.
//
//

import Foundation
import CoreData

extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?

}

extension Weight : Identifiable {

}
