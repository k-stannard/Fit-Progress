//
//  HomeViewController.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
}

extension HomeViewController {
    
    private func configureNavigationBar() {
        title = "Workouts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .edit)
    }
}
