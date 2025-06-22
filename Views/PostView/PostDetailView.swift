//
//  PostDetailView.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import Foundation
import UIKit
import Combine
import SnapKit

class PostDetailView: UIViewController{
    
    private let postDetailVM: PostDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PostDetailViewModel) {
        self.postDetailVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    private let dislikesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindingViewModel()
    }
    
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(tagsLabel)
        view.addSubview(likesLabel)
        view.addSubview(dislikesLabel)
        view.addSubview(viewsLabel)
        view.addSubview(userIdLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(8)
        }
        tagsLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }
        dislikesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likesLabel)
            make.left.equalTo(likesLabel.snp.right).offset(16)
        }
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }
        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    private func bindingViewModel() {
        postDetailVM.fetchDetail()
        
        postDetailVM.$postDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] post in
                self?.titleLabel.text = post.title
                self?.bodyLabel.text = post.body
                self?.tagsLabel.text = "Tags: " + post.tags.joined(separator: ", ")
                self?.likesLabel.text = "Likes: \(post.reactions.likes)"
                self?.dislikesLabel.text = "Dislikes: \(post.reactions.dislikes)"
                self?.viewsLabel.text = "Views: \(post.views)"
                self?.userIdLabel.text = "User ID: \(post.userId)"
            }
            .store(in: &cancellables)
    }
    
}

