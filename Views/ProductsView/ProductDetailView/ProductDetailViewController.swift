//
//  ProductDetailViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let product: ProductModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let warrantyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let shippingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let returnPolicyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let minimumOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let reviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("查看評論", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.label
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        return button
    }()
    
    private let tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(product: ProductModel) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProductNavg() {
        self.title = "商品細項"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAdd() {
        print("Add to cart tapped")
    }

    
    @objc private func showReviews() {
        let reviewVC = ReviewsViewController(reviews: product.reviews ?? [])
        reviewVC.title = "所有評論"
        let nav = UINavigationController(rootViewController: reviewVC)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .medium(),
                .large()
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupProductNavg()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        setupTagsCollectionView()
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(ratingLabel)
        
        contentView.addSubview(warrantyLabel)
        contentView.addSubview(shippingLabel)
        contentView.addSubview(returnPolicyLabel)
        contentView.addSubview(minimumOrderLabel)
        contentView.addSubview(barcodeLabel)
        contentView.addSubview(qrCodeImageView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }

        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(priceLabel.snp.trailing).offset(16)
        }

        stockLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        warrantyLabel.snp.makeConstraints { make in
            make.top.equalTo(stockLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        shippingLabel.snp.makeConstraints { make in
            make.top.equalTo(warrantyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        returnPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        minimumOrderLabel.snp.makeConstraints { make in
            make.top.equalTo(returnPolicyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        barcodeLabel.snp.makeConstraints { make in
            make.top.equalTo(minimumOrderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        qrCodeImageView.snp.makeConstraints { make in
            make.top.equalTo(barcodeLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(120)
        }

        contentView.addSubview(reviewButton)
        reviewButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(qrCodeImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        reviewButton.addTarget(self, action: #selector(showReviews), for: .touchUpInside)
    }
    
    private func setupTagsCollectionView() {
        contentView.addSubview(tagsCollectionView)
        tagsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
    }
    
    private func configureUI() {
        if let urlString = product.thumbnail, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        if let brand = product.brand, !brand.isEmpty {
            brandLabel.text = "【\(brand)】"
            brandLabel.isHidden = false
        } else {
            brandLabel.isHidden = true
        }
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = String(format: "$ %.2f", product.price ?? 0)
        stockLabel.text = product.stock != nil ? "庫存：\(product.stock!)" : "庫存：無資料"
        let rating = product.rating ?? 0
        let starCount = Int(rating.rounded())
        let stars = String(repeating: "⭐️", count: starCount)
        ratingLabel.text = stars.isEmpty ? "無評分" : stars
        tagsCollectionView.reloadData()
        
        warrantyLabel.text = "保固：\(product.warrantyInformation ?? "無")"
        shippingLabel.text = "運送資訊：\(product.shippingInformation ?? "無")"
        returnPolicyLabel.text = "退貨政策：\(product.returnPolicy ?? "無")"
        minimumOrderLabel.text = "最小訂購量：\(product.minimumOrderQuantity.map { "\($0)" } ?? "無")"
        
        barcodeLabel.text = "條碼：\(product.meta?.barcode ?? "無")"
        
        if let qrCodeURLString = product.meta?.qrCode,
           let qrCodeURL = URL(string: qrCodeURLString) {
            qrCodeImageView.sd_setImage(with: qrCodeURL, placeholderImage: UIImage(systemName: "qrcode"))
        }
    }
    
}

extension ProductDetailViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath)
        let labelTag = UILabel()
        labelTag.font = .systemFont(ofSize: 16)
        labelTag.textColor = .systemBackground
        labelTag.backgroundColor = .label
        labelTag.layer.cornerRadius = 12
        labelTag.clipsToBounds = true
        labelTag.textAlignment = .center
        let tag = product.tags?[indexPath.item] ?? ""
        labelTag.text = " \(tag) "
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(labelTag)
        labelTag.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = product.tags?[indexPath.item] ?? ""
        let width = tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 16
        return CGSize(width: width, height: 30)
    }
}

   
