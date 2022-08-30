//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Exercise>!
    let context = CoreDataManager.shared.container.viewContext
    
    var isWorkoutUpdated: Bool = false
    
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let emptyStateView = EmptyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureEmptyStateView()
        loadSavedData()
        getCoreDataDBPath()
    }
    
    func getCoreDataDBPath() {
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding

            print("Core Data DB Path :: \(path ?? "Not found")")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkWorkoutIsEmpty()
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

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
    }
    
    @objc private func handleLogAlert() {
        let message = "Would you like to add a new workout or log your workout weight?"
        let alert = UIAlertController(title: "Log Alert", message: message, preferredStyle: .alert)
        
        let newView = UIViewController()
        newView.view.backgroundColor = .white
        
        alert.addAction(UIAlertAction(title: "New Workout", style: .default) { _ in
            self.presentAddWorkoutController()
        })
        
        alert.addAction(UIAlertAction(title: "Log Workout", style: .default) { _ in
            self.present(newView, animated: true)
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
}

extension HomeViewController: AddWorkoutDelegate {
    
    func saveNewWorkout(with workout: String, exercise: String) {
        CoreDataManager.shared.createExercise(workout: workout, name: exercise)
        isWorkoutUpdated.toggle()
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<Exercise>(entityName: "Exercise")
            let createdSort = NSSortDescriptor(key: "createdAt", ascending: true)
            
            request.sortDescriptors = [createdSort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "workout",
                                                                  cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async { self.tableView.reloadData() }
        } catch let error {
            print("failed to load saved data: \(error)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexPath = indexPath, let newIndexPath = newIndexPath {
            tableView.performBatchUpdates {
                switch type {
                case .insert:
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                    self.tableView.reloadData()
                case .delete:
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .update:
                    tableView.reloadRows(at: [indexPath], with: .fade)
                case .move:
                    tableView.moveRow(at: indexPath, to: newIndexPath)
                default:
                    break
                }
            }

        }
    }
}

// MARK: - UITableViewDataSource
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
        cell.accessoryType = .disclosureIndicator
        
        let exercise = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController!.sections!
        return sectionInfo[section].name
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = UIViewController()
        newView.view.backgroundColor = .white
        newView.title = "New View"
        
        navigationController?.pushViewController(newView, animated: true)
    }
}
