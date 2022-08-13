//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var headers = ["Push", "Pull", "Legs"]
    
    var sections = [
        ["A", "B", "C", "D", "E"],
        ["A", "B", "C", "D", "E"],
        ["A", "B", "C", "D", "E"]
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(handleLogAlert))
        navigationItem.leftBarButtonItem = editButtonItem
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
    
    private func addWorkoutToList() {
        headers.append("New Section")
        sections.append([""])
        
        let indexSet = IndexSet(integer: headers.count - 1)
        tableView.performBatchUpdates {
            tableView.insertSections(indexSet, with: .fade)
        } completion: { _ in
            print("New Section Added")
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(editing, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headers[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
