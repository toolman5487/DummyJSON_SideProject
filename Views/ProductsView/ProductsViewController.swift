//
//  ProductsViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit

class ProductsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductTitle()
    }

    private func setupProductTitle() {
        self.title = "商品列表"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
