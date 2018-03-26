//
//  CustomTabBarController.swift
//  fbMessager
//
//  Created by MAC on 3/26/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let friendController = ViewController()
        let recentMessagesNavController = UINavigationController(rootViewController: friendController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [
            recentMessagesNavController,
            createDummyNavControllerWithTitle(title: "Calls", image: #imageLiteral(resourceName: "calls")),
            createDummyNavControllerWithTitle(title: "Groups", image: #imageLiteral(resourceName: "groups")),
            createDummyNavControllerWithTitle(title: "People", image: #imageLiteral(resourceName: "people")),
            createDummyNavControllerWithTitle(title: "Settings", image: #imageLiteral(resourceName: "setting"))
        ]
    }
    
    private func createDummyNavControllerWithTitle(title: String, image: UIImage) -> UINavigationController {
        let vc = UIViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
