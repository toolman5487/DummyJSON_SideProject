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
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView()
    private let productVM = ProductsViewModel()
    private var products: [ProductModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavg()
        setupTableView()
        bindViewModel()
        productVM.fetchProducts()
    }
    
    private func setupNavg() {
        self.title = "商品列表"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTable))
        refreshItem.tintColor = .systemBackground
        navigationItem.rightBarButtonItem = refreshItem
    }
    
    @objc private func refreshTable() {
        productVM.fetchProductPage(limit: 30, skip: 0)
    }
    
    @objc private func handleRefresh() {
        let offsetPoint = CGPoint(x: 0, y: -refreshControl.frame.size.height - 40) 
        tableView.setContentOffset(offsetPoint, animated: true)
        refreshControl.beginRefreshing()
        productVM.fetchProductPage(limit: 30, skip: 0)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .systemBackground
    }
    
    private func bindViewModel() {
        productVM.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
                print("Renew List Count:", products.count)
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
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
