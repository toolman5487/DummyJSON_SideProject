//
//  UsersViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import UIKit
import Combine
import SnapKit
import SDWebImage

class UsersViewController: UIViewController {
    
    private let userVM = UsersViewModel(authService: AuthService())
    private var cancellables = Set<AnyCancellable>()
    
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle")
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.label.cgColor
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
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登出", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsersTitle()
        setupUI()
        bindingVM()
        loadUser()
        setupLogoutButton()
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
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
    private func bindingVM(){
        userVM.$user
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.configUI(with: user)
            }
            .store(in: &cancellables)
        
        userVM.$errorMessage
            .compactMap { $0 }
            .sink {
                print("fetch user error:", $0)
            }
            .store(in: &cancellables)
    }
    
    private func loadUser() {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("DEBUG token:", token)
        userVM.fetchUser(token: token)
    }
    
    private func configUI(with user: UserModel) {
        usernameLabel.text = (user.username.isEmpty == false) ? user.username : "未設定用戶名稱"
        let firstName = user.firstName ?? ""
        let lastName = user.lastName ?? ""
        let fullName = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
        fullNameLabel.text = !fullName.isEmpty ? fullName : "未設定姓名"
        emailLabel.text = (user.email?.isEmpty == false) ? user.email : "未設定 Email"
        if let urlString = user.image, !urlString.isEmpty, let url = URL(string: urlString) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    private func setupLogoutButton() {
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    @objc private func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        print("Remove Token")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}
