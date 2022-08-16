//
//  AddWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/15/22.
//

import UIKit

class AddWorkoutViewController: UIViewController {
    
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
        print("Save button tapped")
    }
}
