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
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private var tags: [String] = ["swift", "combine", "mvvm", "uikit", "sdwebimage", "snapkit", "api", "json", "ios", "apple"]
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = CGSize(width: 60, height: 30)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier)
        return collection
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    private let dislikesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        setupUI()
        bindingViewModel()
    }
    
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(tagsCollectionView)
        view.addSubview(bodyLabel)
        view.addSubview(likesLabel)
        view.addSubview(dislikesLabel)
        view.addSubview(viewsLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(8)
        }
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(36)
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(8)
        }
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(12)
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
        
    }
    
    private func bindingViewModel() {
        postDetailVM.fetchDetail()
        
        postDetailVM.$postDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] post in
                self?.titleLabel.text = post.title
                self?.bodyLabel.text = post.body
                self?.likesLabel.text = "Likes: \(post.reactions.likes)"
                self?.dislikesLabel.text = "Dislikes: \(post.reactions.dislikes)"
                self?.viewsLabel.text = "Views: \(post.views)"
                self?.navigationItem.title = "User \(post.userId)"
            }
            .store(in: &cancellables)
    }
    
}

extension PostDetailView:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as! TagCollectionViewCell
        cell.configure(with: tags[indexPath.item])
        return cell
    }
    
    
}
