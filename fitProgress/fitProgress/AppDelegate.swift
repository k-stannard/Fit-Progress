//
//  AppDelegate.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        let homeViewController = HomeViewController(coreDataManager: CoreDataManager())
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        
        return true
    }
}
