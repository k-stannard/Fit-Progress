//
//  SelectWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 9/7/22.
//

import UIKit
import CoreData

protocol SelectWorkoutDelegate: AnyObject {
    func fetchExercises(from workout: String)
}

class SelectWorkoutViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let context = CoreDataManager.shared.container.viewContext
    weak var delegate: SelectWorkoutDelegate?
    
    var workouts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureTableView()
        layoutTableView()
        loadFetchedData()
    }
}

// MARK: - Configuration & Layout Methods
extension SelectWorkoutViewController {
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = .tertiarySystemGroupedBackground
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
}

// MARK: - CoreData Methods
extension SelectWorkoutViewController {
    
    private func loadFetchedData() {
        let attributeToFetch = "workout.name"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.propertiesToFetch = [attributeToFetch]
        
        do {
            if let result = try context.fetch(request) as? [[String: String]] {
                workouts = result.compactMap { $0[attributeToFetch] }
            }
        } catch let error {
            print("Could not fetch: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource Methods
extension SelectWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let exercise = workouts[indexPath.row]
        cell.textLabel?.text = exercise
        return cell
    }
}

// MARK: - UITableViewDelegate Methods
extension SelectWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        self.delegate?.fetchExercises(from: workout)
        navigationController?.popViewController(animated: true)
    }
}
