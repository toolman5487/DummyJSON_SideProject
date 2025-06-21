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
        setupTabBarBlur()
    }
    
    func mainTabBar(){
        
        let postService = PostService()
        let postVM = PostViewModel(postService: postService)
        let postVC = PostHomeViewController(viewModel: postVM)
        postVC.tabBarItem = UITabBarItem(title: "社群", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let productsVC = ProductsViewController()
        productsVC.tabBarItem = UITabBarItem(title: "購物", image: UIImage(systemName: "cart.fill"), tag: 1)
        
        let usersVC = UsersViewController()
        usersVC.tabBarItem = UITabBarItem(title: "使用者", image: UIImage(systemName: "person.2.fill"), tag: 2)
        
        self.viewControllers = [
            UINavigationController(rootViewController: postVC),
            UINavigationController(rootViewController: productsVC),
            UINavigationController(rootViewController: usersVC)
        ]
    }
    
    private func setupTabBarBlur() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
    }
}
