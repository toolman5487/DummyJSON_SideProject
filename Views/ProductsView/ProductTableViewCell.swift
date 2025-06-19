//
//  ProductTableViewCell.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class ProductTableViewCell: UITableViewCell {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumbnailImageView.snp.right).offset(8)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        stockLabel.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right).offset(12)
            make.bottom.equalTo(priceLabel)
            make.right.lessThanOrEqualToSuperview().inset(16)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: ProductModel) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description ?? "--"
        priceLabel.text = "$\(product.price ?? 0)"
        stockLabel.text = "庫存：\(product.stock ?? 0)"
        if let urlString = product.thumbnail, let url = URL(string: urlString) {
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.image = UIImage(systemName: "photo")
        }
    }
}
