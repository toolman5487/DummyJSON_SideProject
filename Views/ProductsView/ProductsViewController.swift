//
//  ProductsViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit
import Combine

class ProductsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = ProductsViewModel()
    private var products: [ProductModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupTableView()
        bindViewModel()
        viewModel.fetchProducts()
    }
    
    private func setupTitle() {
        self.title = "商品列表"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func bindViewModel() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
                print("目前產品數量：", products.count)
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    
}
