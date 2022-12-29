//
//  LogWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/31/22.
//

import UIKit
import CoreData

class LogWorkoutViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let coreDataManager: CoreDataManager
    private let childContext: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = coreDataManager.persistentContainer.viewContext
        
        self.childContext = childContext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        
        request.sortDescriptors = [idSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: childContext,
            sectionNameKeyPath: "name",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var selectedWorkout: String?
    var hasSelectedWorkout = false
    var exercises = [Exercise]()
    var textFieldValues = NSMutableDictionary()
    
    var sortedKeys = [Int64]() {
        didSet {
            if oldValue != sortedKeys {
                self.tableView.reloadData()
            }
        }
    }
    
    var exerciseSets: [Int64: [Set]] = [:] {
        didSet {
            sortedKeys = exerciseSets.keys.sorted()
        }
    }
    
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
    
    private func configureFooterView(_ section: Int) -> UIView {
        let footerView = AddRowFooterView(title: "Add set")
        footerView.addRowButton.addTarget(self, action: #selector(handleAddRow), for: .touchUpInside)
        footerView.addRowButton.tag = section
        return footerView
    }
}

// MARK: - SelectWorkoutDelegate Protocol Methods
extension LogWorkoutViewController:  SelectWorkoutDelegate {
    
    func fetchExercises(from workout: String) {
        selectedWorkout = workout
        hasSelectedWorkout = true

        do {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "workout.name ==[c] '\(workout)'")
            try fetchedResultsController.performFetch()
            
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
            exercises = fetchedObjects.map { $0 }
            
            exerciseSets = coreDataManager.initializeSets(for: exercises, in: childContext)
            
            DispatchQueue.main.async { self.tableView.reloadData() }
        } catch let error {
            print("Failed to load saved data: \(error)")
        }
    }
}

// MARK: - Button Action Methods
extension LogWorkoutViewController {
    
    private func persistChildContextChanges() {
        if childContext.hasChanges { print("Child context has changes, saving..") }
        do {
            try childContext.save()
            print("child context saved")
        } catch let error {
            print("Failed to save to child context with error: \(error)")
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        view.endEditing(true)
        
        defer {
            dismiss(animated: true)
        }
        
        do {
            try coreDataManager.persistentContainer.viewContext.save()
            print("Parent context saved")
        } catch let error {
            print("Failed to save parent context: \(error)")
        }
    }
    
    @objc private func handleAddRow(_ sender: UIButton) {
        let section = sender.tag
        let row = (exerciseSets[Int64(section)]?.count ?? 0)
        
        tableView.beginUpdates()
        let indexPath = IndexPath(row: row, section: section)
        tableView.insertRows(at: [indexPath], with: .automatic)
        let set = coreDataManager.addSet(to: exercises[section - 1], in: childContext)
        exerciseSets[Int64(section)]?.append(set)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource Methods
extension LogWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let fetchedObjects = fetchedResultsController.fetchedObjects
        return 1 + (fetchedObjects?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSelectedWorkout {
            return section == 0 ? 1 : exerciseSets[sortedKeys[section - 1]]?.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = SelectWorkoutCell(style: .value1, reuseIdentifier: SelectWorkoutCell.reuseId)
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = selectedWorkout
            
            return cell
        default:
            let cell = LogExerciseCell(style: .default, reuseIdentifier: LogExerciseCell.reuseid)
            cell.selectionStyle = .none
            cell.nameLabel.text = "Set \(indexPath.row + 1)"
            cell.configureCellTextFields(with: self, indexPath: indexPath)
            
            let weightIndex = CustomIndexPath(item: indexPath.item, section: indexPath.section, textFieldIndex: 0)
            let repsIndex = CustomIndexPath(item: indexPath.item, section: indexPath.section, textFieldIndex: 1)
            let rirIndex = CustomIndexPath(item: indexPath.item, section: indexPath.section, textFieldIndex: 2)
            
            cell.weightTextField.text = textFieldValues[weightIndex] as? String
            cell.repsTextField.text = textFieldValues[repsIndex] as? String
            cell.rirTextField.text = textFieldValues[rirIndex] as? String
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return " "
        } else {
            if hasSelectedWorkout {
                let object = fetchedResultsController.object(at: IndexPath(row: 0, section: section - 1))
                return object.name
            }
        }

        return nil
    }
}

// MARK: - UITableViewDelegate Methods
extension LogWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        section == 0 ? nil : configureFooterView(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectWorkoutVC = SelectWorkoutViewController(coreDataManager: coreDataManager)
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
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        guard let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable) else { return }
        let sectionKey = sortedKeys[textFieldIndexPath.section - 1]
        guard let setArray = exerciseSets[sectionKey] else { return }
        let set = setArray[textFieldIndexPath.row]
        
        let index = CustomIndexPath(item: objectIndex, section: textFieldIndexPath.section, textFieldIndex: textFieldIndex)
        
        if !textField.isEditing && !text.isEmpty {
            switch textFieldIndexPath.row {
            case 0..<setArray.count:
                textFieldValues[index] = text
                
                switch textFieldIndex {
                case 0:
                    set.weight = Double(text)!
                case 1:
                    set.reps = Int64(text)!
                case 2:
                    set.rir = Double(text)!
                default:
                    return
                }
            default:
                return
            }
        }
    
        persistChildContextChanges()
    }
}
