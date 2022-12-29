//
//  CoreDataManager.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/26/22.
//

import CoreData

struct CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Exercise")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData store failed to load with error: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    
    @discardableResult
    func createNewWorkout(workout title: String, exercise name: String, id: Int64) -> Exercise? {
        let context = persistentContainer.viewContext
        
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
        let context = persistentContainer.viewContext
        context.delete(exercise)
        
        do {
            try context.save()
        } catch let error {
            print("Failed to delete: \(error)")
        }
    }
    
    func initializeSets(for exercises: [Exercise], in context: NSManagedObjectContext) -> [Int64: [Set]] {
        var dict: [Int64: [Set]] = [:]
        
        exercises.forEach { exercise in
            dict[exercise.id] = []
            for _ in 1...3 {
                dict[exercise.id]?.append(addSet(to: exercise, in: context))
            }
        }

        return dict
    }
    
    func addSet(to exercise: Exercise, in context: NSManagedObjectContext) -> Set {
        let set = Set(context: context)
        set.sessionDate = Date()
        set.id = exercise.id
        set.exercise = exercise
        
        return set
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
