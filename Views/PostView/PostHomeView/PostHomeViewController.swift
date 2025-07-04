//
//  TodoListViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import UIKit
import Combine
import SnapKit

class PostHomeViewController: UIViewController {
    
    private let postVM: PostViewModel
    private var cancellables = Set<AnyCancellable>()
    init(viewModel: PostViewModel) {
        self.postVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private var postInputContainer: UIView?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let postInputButton: UIButton = {
        let button = UIButton()
        button.setTitle("發生什麼事？", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupTodoTitle()
        setupLayout()
        bindingVM()
        postVM.fetchInitialPosts()
    }
    
    private func setupTodoTitle() {
        self.title = "社群"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupLayout() {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        container.addSubview(avatarImageView)
        container.addSubview(postInputButton)
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        postInputButton.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        postInputButton.addTarget(self, action: #selector(didTapInput), for: .touchUpInside)
        postInputContainer = container
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    @objc private func didTapInput() {
        print("點擊發文輸入框")
    }
    
    private func bindingVM(){
        postVM.$posts
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension PostHomeViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "貼文"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postVM.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell {
            let post = postVM.posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = postVM.posts[indexPath.row]
        let detailService = PostDetailService()
        let detailVM = PostDetailViewModel(postId: post.id, service: detailService)
        let detailVC = PostDetailView(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
