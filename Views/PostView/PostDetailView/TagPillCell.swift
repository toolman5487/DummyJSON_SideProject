//
//  TagPillCell.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/23.
//

import UIKit
import SnapKit

class TagPillCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.layoutIfNeeded()
        label.layer.cornerRadius = label.frame.height / 2
    }

    func configure(with text: String) {
        label.text = text
    }
}
