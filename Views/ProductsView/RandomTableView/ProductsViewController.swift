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
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavg()
        setupSearchController()
        setupTableView()
        bindViewModel()
        productVM.fetchProducts()
    }
    
    private func setupNavg() {
        self.title = "購買"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜尋商品"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.searchTextField.textColor = .label
        searchController.searchBar.searchTextField.tintColor = .label
    }
    
    @objc private func handleRefresh() {
        let offsetPoint = CGPoint(x: 0, y: -refreshControl.frame.size.height - 40)
        tableView.setContentOffset(offsetPoint, animated: true)
        refreshControl.beginRefreshing()
        productVM.fetchProducts()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = products[indexPath.row]
        let detailVC = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProductsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            products = productVM.products
            tableView.reloadData()
            return
        }
        products = productVM.products.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            ($0.tags?.contains(where: { $0.localizedCaseInsensitiveContains(query) }) ?? false)
        }
        tableView.reloadData()
    }
}
