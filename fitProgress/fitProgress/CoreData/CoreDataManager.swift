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
    func createNewWorkout(workout title: String, exercise name: String, id: Int64) -> Exercise? {
        let context = container.viewContext
        
        let exercise = Exercise(context: context)
        exercise.name = name
        exercise.createdAt = Date()
        exercise.id = id
        
        if exercise.workout == nil {
            let newWorkout = Workout(context: context)
            newWorkout.name = title
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
    
    func initializeSets(for exercises: [Exercise]) -> [Int64: [Set]] {
        var dict: [Int64: [Set]] = [:]
        
        exercises.forEach { exercise in
            dict[exercise.id] = []
            for _ in 1...3 {
                dict[exercise.id]?.append(addSet(to: exercise))
            }
        }

        return dict
    }
    
    func addSet(to exercise: Exercise) -> Set {
        let context = container.viewContext
        
        let set = Set(context: context)
        set.sessionDate = Date()
        set.id = exercise.id
        set.exercise = exercise
        
        return set
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
