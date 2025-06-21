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
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private enum Section: Int, CaseIterable {
        case basicInfo, contact, address, company
    }
    
    private var userInfo: UserModel?
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle")
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 0
        image.layer.borderColor = nil
        return image
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
        setupTableView()
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        let avatarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 160))
        avatarContainerView.addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        tableView.tableHeaderView = avatarContainerView
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
        let urlString = user.image
        if !urlString.isEmpty, let url = URL(string: urlString) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
        self.userInfo = user
        self.tableView.reloadData()
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

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.allCases.count {
            return 1
        }
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .basicInfo:
            return 2
        case .contact:
            return 2
        case .address:
            return 2
        case .company:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.allCases.count {
            return nil
        }
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .basicInfo: return "基本資料"
        case .contact: return "聯絡方式"
        case .address: return "住址"
        case .company: return "公司資訊"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = .label
        cell.selectionStyle = .none
        
        if indexPath.section == Section.allCases.count {
            cell.textLabel?.text = "登出"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemRed
            cell.selectionStyle = .default
            return cell
        }
        
        guard let section = Section(rawValue: indexPath.section), let user = userInfo else {
            cell.textLabel?.text = "資料錯誤"
            return cell
        }
        
        switch section {
        case .basicInfo:
            if indexPath.row == 0 {
                cell.textLabel?.text = "用戶名稱：\(user.username)"
            } else {
                let fullName = [user.firstName ?? "", user.lastName ?? ""].joined(separator: " ")
                cell.textLabel?.text = "姓名：\(fullName)"
            }
        case .contact:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Email：\(user.email)"
            } else {
                cell.textLabel?.text = "電話：\(user.phone)"
            }
        case .address:
            if indexPath.row == 0 {
                cell.textLabel?.text = "地址：\(user.address?.address ?? "") \(user.address?.city ?? "")"
            } else {
                cell.textLabel?.text = "國家：\(user.address?.country ?? "")"
            }
        case .company:
            if indexPath.row == 0 {
                cell.textLabel?.text = "公司名稱：\(user.company?.name ?? "")"
            } else {
                cell.textLabel?.text = "職稱：\(user.company?.title ?? "")"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.allCases.count {
            handleLogout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
