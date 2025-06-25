//
//  PostTableViewCell.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()

    private let likesIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let viewsIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "book.fill"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(likesIcon)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsIcon)
        contentView.addSubview(viewsLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(likesIcon)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsIcon)
        contentView.addSubview(viewsLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        likesIcon.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }
        likesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likesIcon)
            make.leading.equalTo(likesIcon.snp.trailing).offset(4)
        }
        viewsIcon.snp.makeConstraints { make in
            make.centerY.equalTo(likesIcon)
            make.leading.equalTo(likesLabel.snp.trailing).offset(16)
            make.width.height.equalTo(16)
        }
        viewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsIcon)
            make.leading.equalTo(viewsIcon.snp.trailing).offset(4)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        likesLabel.text = "\(post.reactions.likes)"
        viewsLabel.text = "\(post.views)"
    }
}
