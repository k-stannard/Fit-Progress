//
//  AddWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/15/22.
//

import UIKit

protocol AddWorkoutDelegate: AnyObject {
    func saveNewWorkout(with workout: Lifts)
}

class AddWorkoutViewController: UIViewController {
    
    weak var delegate: AddWorkoutDelegate?
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var numberOfRows = 5

    var name: String = ""
    var exercises: Exercises = Exercises(name: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
        layoutTableView()
        configureFooterView()
    }
}

extension AddWorkoutViewController {
    
    private func configureNavigationBar() {
        title = "New Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    private func configureTableView() {
        tableView.register(AddWorkoutTableViewCell.self, forCellReuseIdentifier: AddWorkoutTableViewCell.reuseid)
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
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
    
    private func configureFooterView() {
        let footerView = AddRowFooterView()
        footerView.addRowButton.addTarget(self, action: #selector(handleAddRow), for: .touchUpInside)
        footerView.frame.size.height = 45
        self.tableView.tableFooterView = footerView
    }
    
    @objc private func handleAddRow() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: numberOfRows, section: 1)
        tableView.insertRows(at: [indexPath], with: .automatic)
        numberOfRows += 1
        tableView.endUpdates()
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        view.endEditing(true)
        let workout = Lifts(name: name, exercises: exercises)
        self.delegate?.saveNewWorkout(with: workout)
        dismiss(animated: true)
    }
}

extension AddWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddWorkoutTableViewCell(style: .default, reuseIdentifier: AddWorkoutTableViewCell.reuseid)
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        cell.textField.tag = indexPath.row
        
        switch indexPath.section {
        case 0:
            cell.textField.placeholder = "Enter workout name"
        default:
            cell.textField.tag = indexPath.row + 1
            cell.textField.placeholder = "Enter exercise name"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Workout" : "Exercises"
    }
}

extension AddWorkoutViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            name = textField.text!
        default:
            let exercise = textField.text!
            if !textField.isEditing && textField.text != "" {
                if !exercises.name.contains(exercise) {
                    exercises.name.append(exercise)
                }
            }
        }
    }
}
