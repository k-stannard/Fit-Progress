//
//  LogWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/31/22.
//

import UIKit

class LogWorkoutViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let text = ["Bench Press", "Overhead Press", "Incline Cables", "Dips", "Tricep Pushdown"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        configureNavigationBar()
        configureTableView()
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
        section == 0 ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = SelectWorkoutCell(style: .value1, reuseIdentifier: SelectWorkoutCell.reuseId)
            cell.accessoryType = .disclosureIndicator
            
            cell.detailTextLabel?.text = "Chest"
            return cell
        case 1:
            let cell = LogExerciseCell(style: .default, reuseIdentifier: LogExerciseCell.reuseid)
            let content = text[indexPath.row]
            cell.nameLabel.text = content
            cell.weightTextField.delegate = self
            cell.setsTextField.delegate = self
            cell.repsTextField.delegate = self
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Workout" : "Log Exercises"
    }
}

extension LogWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            navigationController?.pushViewController(SelectWorkoutViewController(), animated: true)
        }
    }
}

extension LogWorkoutViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 3
    }
}
