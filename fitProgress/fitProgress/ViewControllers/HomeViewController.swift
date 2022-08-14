//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit

struct Lifts: Hashable {
    var name: String
    var exercises: [String]
}

class HomeViewController: UIViewController {
        
    var lifts = [
        Lifts(name: "Push", exercises: ["A", "B", "C", "D", "E"]),
        Lifts(name: "Pull", exercises: ["A", "B", "C", "D", "E"]),
        Lifts(name: "Legs", exercises: ["A", "B", "C", "D", "E"])
    ]
    
    var tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
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
        setupTableViewLayout()
    }
    
    private func setupTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func handleLogAlert() {
        let message = "Would you like to add a new workout or log your workout weight?"
        let alert = UIAlertController(title: "Log Alert", message: message, preferredStyle: .alert)
        
        let newView = UIViewController()
        newView.view.backgroundColor = .white
        
        alert.addAction(UIAlertAction(title: "New Workout", style: .default) { _ in
            self.addWorkoutToList()
        })
        
        alert.addAction(UIAlertAction(title: "Log Workout", style: .default) { _ in
            self.present(newView, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(editing, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        lifts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lifts[section].exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = lifts[indexPath.section].exercises[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        lifts[section].name
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExerciseFromWorkout(with: indexPath)
        }
    }
    
    private func deleteExerciseFromWorkout(with indexPath: IndexPath) {
        lifts[indexPath.section].exercises.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        print(lifts.count)
        print(lifts[indexPath.section])
        
        tableView.performBatchUpdates {
            if lifts[indexPath.section].exercises.isEmpty {
                let currentSection = indexPath.section
                let nextSection = currentSection + 1
                
                print("Current sectin: \(currentSection). Next section: \(nextSection)")
                
                if lifts[indexPath.section] != lifts.last {
                    
                    lifts.remove(at: indexPath.section)
                    
                    let indexSet = IndexSet(integer: indexPath.section)
                    tableView.deleteSections(indexSet, with: .fade)
                    tableView.moveSection(nextSection, toSection: currentSection)
                } else {
                    lifts.remove(at: indexPath.section)
                    
                    let indexSet = IndexSet(integer: indexPath.section)
                    tableView.deleteSections(indexSet, with: .fade)
                }
            }
        }
    }
    
    private func addWorkoutToList() {
        lifts.append(Lifts(name: "New workout", exercises: [""]))
        
        let indexSet = IndexSet(integer: lifts.count - 1)
        tableView.insertSections(indexSet, with: .fade)
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
