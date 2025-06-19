//
//  ReviewTableViewCell.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import UIKit
import SnapKit
import Combine
import SDWebImage

class ReviewTableViewCell: UITableViewCell {
    let ratingLabel = UILabel()
    let commentLabel = UILabel()
    let reviewerLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        commentLabel.font = UIFont.systemFont(ofSize: 15)
        commentLabel.numberOfLines = 0
        reviewerLabel.font = UIFont.systemFont(ofSize: 13)
        reviewerLabel.textColor = .gray
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray

        contentView.addSubview(ratingLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(reviewerLabel)
        contentView.addSubview(dateLabel)

        ratingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(6)
            make.left.equalTo(ratingLabel)
            make.right.equalToSuperview().offset(-16)
        }

        reviewerLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(6)
            make.left.equalTo(ratingLabel)
            make.bottom.equalToSuperview().offset(-12)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reviewerLabel)
            make.right.equalToSuperview().offset(-16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
