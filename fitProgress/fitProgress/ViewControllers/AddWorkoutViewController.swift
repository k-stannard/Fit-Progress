//
//  AddWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/15/22.
//

import UIKit

protocol AddWorkoutDelegate: AnyObject {
    func saveNewWorkout(name: String, exercises: [String])
}

class AddWorkoutViewController: UIViewController {
    
    weak var delegate: AddWorkoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
}

extension AddWorkoutViewController {
    
    private func configureNavigationBar() {
        title = "New Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        self.delegate?.saveNewWorkout(name: "Arms", exercises: ["Hammer Curls", "Cable Curls", "Skullcrusher", "French Press"])
        dismiss(animated: true)
    }
}
