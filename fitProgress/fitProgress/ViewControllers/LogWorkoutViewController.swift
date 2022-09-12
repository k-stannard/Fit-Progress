//
//  LogWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/31/22.
//

import UIKit
import CoreData

class LogWorkoutViewController: UIViewController {
    
    let context = CoreDataManager.shared.container.viewContext
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var selectedWorkout: String?
    var exercises = [Exercise]()
    
    lazy var weight = [String](repeating: "", count: exercises.count)
    lazy var reps = [String](repeating: "", count: exercises.count)
    lazy var sets = [String](repeating: "", count: exercises.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - Configuration & Layout Methods
extension LogWorkoutViewController {
    
    private func configureNavigationBar() {
        title = "Log Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    private func configureTableView() {
        tableView.register(LogExerciseCell.self, forCellReuseIdentifier: LogExerciseCell.reuseid)
        tableView.register(SelectWorkoutCell.self, forCellReuseIdentifier: SelectWorkoutCell.reuseId)
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

// MARK: - SelectWorkoutDelegate Protocol Methods
extension LogWorkoutViewController:  SelectWorkoutDelegate {
    
    func fetchExercises(from workout: String) {
        selectedWorkout = workout
        loadFetchedData(from: workout)
    }
}

// MARK: - CoreData Methods
extension LogWorkoutViewController: NSFetchedResultsControllerDelegate {
    
    private func loadFetchedData(from workout: String) {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        request.predicate = NSPredicate(format: "workout contains '\(workout)'")
        
        do {
            if let result = try? context.fetch(request) {
                exercises = result.compactMap { $0 }
                print(exercises)
            }
        }
    }
}

// MARK: - Button Action Methods
extension LogWorkoutViewController {
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        print("save button tapped")
    }
}

// MARK: - UITableViewDataSource Methods
extension LogWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = SelectWorkoutCell(style: .value1, reuseIdentifier: SelectWorkoutCell.reuseId)
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = selectedWorkout
            
            return cell
        case 1:
            let cell = LogExerciseCell(style: .default, reuseIdentifier: LogExerciseCell.reuseid)
            let exercise = exercises[indexPath.row]
            cell.selectionStyle = .none
            cell.nameLabel.text = exercise.name
            cell.configureCellTextFields(with: self, indexPath: indexPath)
            
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return " "
        } else if !exercises.isEmpty {
            return "Log Exercises"
        }
        
        return nil
    }
}

// MARK: - UITableViewDelegate Methods
extension LogWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectWorkoutVC = SelectWorkoutViewController()
            selectWorkoutVC.delegate = self
            navigationController?.pushViewController(selectWorkoutVC, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension LogWorkoutViewController: UITextFieldDelegate {
    
    // Limit # of characters user can enter to 3 max
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 3
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let tag = textField.tag
        let textFieldIndex = tag % 100
        let objectIndex = tag / 100
        
        if !textField.isEditing && !text.isEmpty {
            switch textFieldIndex {
            case 0:
                storeUserText(to: &weight, from: textField, at: objectIndex)
            case 1:
                storeUserText(to: &sets, from: textField, at: objectIndex)
            case 2:
                storeUserText(to: &reps, from: textField, at: objectIndex)
            default:
                break
            }
        }
    }
    
    func storeUserText(to array: inout [String], from textField: UITextField, at index: Int) {
        guard let text = textField.text else { return }
        array.remove(at: index)
        array.insert(text, at: index)
    }
}
