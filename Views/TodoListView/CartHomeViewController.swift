//
//  TodoListViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit

class CartHomeViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTodoTitle()
    }
    
    private func setupTodoTitle() {
        self.title = "購物車"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
