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
        let productsVC = ProductsViewController()
        productsVC.tabBarItem = UITabBarItem(title: "產品", image: UIImage(systemName: "cart.fill"), tag: 0)

        let todoListVC = TodoListViewController()
        todoListVC.tabBarItem = UITabBarItem(title: "待辦", image: UIImage(systemName: "checklist"), tag: 1)
        
        let usersVC = UsersViewController()
        usersVC.tabBarItem = UITabBarItem(title: "使用者", image: UIImage(systemName: "person.2.fill"), tag: 2)

        self.viewControllers = [
            UINavigationController(rootViewController: productsVC),
            UINavigationController(rootViewController: todoListVC),
            UINavigationController(rootViewController: usersVC)
        ]
    }
}
