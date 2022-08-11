//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    let listView = UIHostingController(rootView: WorkoutListView())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureWorkoutListView()
    }
}

extension HomeViewController {
    
    private func configureNavigationBar() {
        title = "Workouts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(setupLogAlert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .edit)
    }
    
    private func configureWorkoutListView() {
        addChild(listView)
        view.addSubview(listView.view)
        setupListViewConstraints()
    }
    
    private func setupListViewConstraints() {
        listView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.view.topAnchor.constraint(equalTo: view.topAnchor),
            listView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func setupLogAlert() {
        let message = "Would you like to add a new workout or log your workout weight?"
        let alert = UIAlertController(title: "Log Alert", message: message, preferredStyle: .alert)
        
        let newView = UIViewController()
        newView.view.backgroundColor = .white
        
        alert.addAction(UIAlertAction(title: "New Workout", style: .default) { _ in
            self.present(newView, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Log Workout", style: .default) { _ in
            self.present(newView, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
