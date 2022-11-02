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
        exercise.name = name
        exercise.createdAt = Date()
        exercise.id = UUID()
        
        if exercise.workout == nil {
            let newWorkout = Workout(context: context)
            newWorkout.name = workout
            newWorkout.createdAt = Date()
            
            exercise.workout = newWorkout
        }
        
        do {
            try context.save()
            return exercise
        } catch let error {
            print("Failed to create: \(error)")
        }
        
        return nil
    }
    
    func deleteExercise(exercise: Exercise) {
        let context = container.viewContext
        context.delete(exercise)
        
        do {
            try context.save()
        } catch let error {
            print("Failed to delete: \(error)")
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
