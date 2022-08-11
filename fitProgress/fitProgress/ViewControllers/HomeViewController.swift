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
}
