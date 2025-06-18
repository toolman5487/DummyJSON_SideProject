//
//  LoginViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit
import SnapKit
import Combine
import CombineCocoa


class LoginViewController:UIViewController{
    
    private let authVM = AuthViewModel(authService: AuthService())
    private var cancellables = Set<AnyCancellable>()
    
    private let usernameField: UITextField = {
        let text = UITextField()
        text.placeholder = "帳號"
        text.text = "emilys"
        text.borderStyle = .roundedRect
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.clearButtonMode = .whileEditing
        return text
    }()
    
    private let eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        button.tintColor = .secondaryLabel
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return button
    }()
    
    private let passwordField: UITextField = {
        let text = UITextField()
        text.placeholder = "密碼"
        text.text = "emilyspass"
        text.borderStyle = .roundedRect
        text.isSecureTextEntry = true
        text.clearButtonMode = .whileEditing
        return text
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登入", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.label
        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitleColor(.label, for: .highlighted)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationTitle()
        setupUI()
        setupEyeButton()
        bindingVM()
    }
    
    private func setupNavigationTitle() {
        self.title = "登入"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupEyeButton() {
        passwordField.rightView = eyeButton
        passwordField.rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.circle" : "eye.slash.circle"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        usernameField.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        passwordField.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func bindingVM(){
        loginButton
            .tapPublisher
            .sink { [weak self] in
                if let self = self {
                    let username = self.usernameField.text ?? ""
                    let password = self.passwordField.text ?? ""
                    self.authVM.login(username: username, password: password)
                }
            }
            .store(in: &cancellables)
        
        authVM.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                print("is Loading")
            }
            .store(in: &cancellables)
        
        authVM.$loginResponse
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
                guard let self = self,
                      let windowScene = self.view.window?.windowScene,
                      let sceneDelegate = windowScene.delegate as? SceneDelegate,
                      let window = sceneDelegate.window else {
                    return
                }
                let tabBarController = MainTabBarController()
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
            .store(in: &cancellables)
        
        authVM.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMsg in
                print("Error: \(errorMsg)")
            }
            .store(in: &cancellables)
    }
}
