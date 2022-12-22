//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        let workoutSort = NSSortDescriptor(key: "workout.name", ascending: true)
        let createdSort = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [workoutSort, createdSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "workout.name",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    let context = CoreDataManager.shared.container.viewContext
    
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let emptyStateView = EmptyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureEmptyStateView()
        loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkWorkoutIsEmpty()
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}

// MARK: - Configuration & Layout Methods
extension HomeViewController {
    
    private func configureNavigationBar() {
        title = "Workouts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(handleLogAlert))
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        layoutEmptyStateView()
    }
    
    private func layoutEmptyStateView() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(editing, animated: true)
    }
    
    private func checkWorkoutIsEmpty() {
        let objects = fetchedResultsController.fetchedObjects?.count
        if objects == 0 {
            emptyStateView.isHidden = false
        } else {
            emptyStateView.isHidden = true
        }
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - Button Action Methods
extension HomeViewController {
    
    @objc private func handleLogAlert() {
        let message = "Would you like to add a new workout or log your workout weight?"
        let alert = UIAlertController(title: "Log Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Workout", style: .default) { _ in
            self.presentAddWorkoutController()
        })
        
        alert.addAction(UIAlertAction(title: "Log Workout", style: .default) { _ in
            self.presentLogWorkoutController()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func presentAddWorkoutController() {
        let addWorkoutVC = AddWorkoutViewController()
        addWorkoutVC.delegate = self
        let navController = UINavigationController(rootViewController: addWorkoutVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    private func presentLogWorkoutController() {
        let logWorkoutVC = LogWorkoutViewController()
        let navController = UINavigationController(rootViewController: logWorkoutVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

// MARK: - AddWorkoutDelegate Methods
extension HomeViewController: AddWorkoutDelegate {
    
    func saveExerciseToWorkout(workout title: String, exercise: String, id: Int64) {
        CoreDataManager.shared.createNewWorkout(workout: title, exercise: exercise, id: id)
    }
}

// MARK: - NSFetchedResultsController Methods
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    private func loadSavedData() {
        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async { self.tableView.reloadData() }
        } catch let error {
            print("Failed to load saved data: \(error)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexPath = indexPath, let newIndexPath = newIndexPath {
            tableView.beginUpdates()
                switch type {
                case .insert:
                    self.tableView.insertRows(at: [newIndexPath], with: .fade)
                case .delete:
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case .update:
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                case .move:
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                default:
                    break
                }
            tableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDataSource Methods
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections![section]
        let objects = sections.numberOfObjects
        return objects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let exercise = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = exercise.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections!
        return sectionInfo[section].name
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let exercise = self.fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.container.viewContext.delete(exercise)
            CoreDataManager.shared.saveContext()
            
            checkWorkoutIsEmpty()
        }
    }
}

// MARK: - UITableViewDelegate Methods
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = UIViewController()
        newView.view.backgroundColor = .white
        newView.title = "New View"
        
        navigationController?.pushViewController(newView, animated: true)
    }
}
