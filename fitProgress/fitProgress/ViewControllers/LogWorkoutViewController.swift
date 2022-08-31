//
//  LogWorkoutViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/31/22.
//

import UIKit

class LogWorkoutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
}

extension LogWorkoutViewController {
    
    private func configureNavigationBar() {
        title = "Log Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        print("save button tapped")
    }
}
