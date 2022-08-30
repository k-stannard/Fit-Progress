//
//  CoreDataManager.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/26/22.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Exercise")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        
        return container
    }()
    
    @discardableResult
    func createExercise(workout: String, name: String) -> Exercise? {
        let context = container.viewContext
        
        let exercise = Exercise(context: context)
        exercise.workout = workout
        exercise.name = name
        exercise.createdAt = Date()
        
        do {
            try context.save()
            return exercise
        } catch let error {
            print("Failed to create: \(error)")
        }
        
        return nil
    }
    
    func fetchExercise() -> [Exercise]? {
        let context = container.viewContext
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        
        do {
            let exercise = try context.fetch(request)
            return exercise
        } catch let error {
            print("Failed to fetch workout: \(error)")
        }
        
        return nil
    }
}
