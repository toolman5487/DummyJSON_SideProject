//
//  UsersViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import UIKit
import SnapKit
import SDWebImage

class UsersViewController: UIViewController {
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    var user: UserModel? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsersTitle()
        setupUI()
        user = UserModel(
            id: 1,
            username: "emilys",
            email: "emily.johnson@example.com",
            firstName: "Emily",
            lastName: "Johnson",
            gender: "female",
            image: "https://dummyjson.com/icon/emilys/128"
        )
    }
    
    private func setupUsersTitle() {
        self.title = "會員資料"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(fullNameLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func updateUI() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        emailLabel.text = user.email
        fullNameLabel.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        
        if let urlString = user.image, let url = URL(string: urlString) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
}
