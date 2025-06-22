//
//  postTagCollectionViewCell.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import Foundation
import UIKit
import SnapKit
import Combine

class TagCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TagCollectionViewCell"
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .label
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(32)
            make.width.greaterThanOrEqualTo(72)
        }
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with text: String) {
        tagLabel.text = text
    }
}
