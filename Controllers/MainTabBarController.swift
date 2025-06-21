//
//  MainTabBarController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit

class MainTabBarController:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar()
    }
    
    func mainTabBar(){
        let postVC = PostHomeViewController()
        postVC.tabBarItem = UITabBarItem(title: "社群", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let productsVC = ProductsViewController()
        productsVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(systemName: "cart.fill"), tag: 1)
        
        let usersVC = UsersViewController()
        usersVC.tabBarItem = UITabBarItem(title: "使用者", image: UIImage(systemName: "person.2.fill"), tag: 2)

        self.viewControllers = [
            UINavigationController(rootViewController: postVC),
            UINavigationController(rootViewController: productsVC),
            UINavigationController(rootViewController: usersVC)
        ]
    }
}
