//
//  LoginViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import UIKit
import SnapKit


class LoginViewController:UIViewController{
    
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "帳號"
        tf.text = "kminchelle"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let eyeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        btn.tintColor = .secondaryLabel
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return btn
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "密碼"
        tf.text = "0lelplR"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("登入", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.backgroundColor = UIColor.label
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.setTitleColor(.label, for: .highlighted)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
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
}
