//
//  TodoListViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit

class TodoListViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTodoTitle()
    }
    
    private func setupTodoTitle() {
        self.title = "待辦項目"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
