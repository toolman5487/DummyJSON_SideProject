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
    
    private lazy var tagCarousel: TagPillCarouselView = {
        let tags: [String] = []
        let view = TagPillCarouselView(tags: tags)
        return view
    }()
    
    private let bodyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemFill
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
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
    
    private lazy var statsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likesLabel, dislikesLabel, viewsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
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
        view.addSubview(tagCarousel)
        view.addSubview(statsContainerView)
        view.addSubview(bodyContainerView)
        bodyContainerView.addSubview(bodyLabel)
        statsContainerView.addSubview(statsStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        tagCarousel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(tagCarousel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(32)
        }
        bodyContainerView.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        statsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
    }
    
    private func bindingViewModel() {
        postDetailVM.fetchDetail()
        
        postDetailVM.$postDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] post in
                guard let post = post else { return }
                self?.titleLabel.text = post.title
                self?.bodyLabel.text = post.body

                let likeAttachment = NSTextAttachment()
                likeAttachment.image = UIImage(systemName: "hand.thumbsup.fill")?.withRenderingMode(.alwaysTemplate)
                likeAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                let likeString = NSMutableAttributedString(attachment: likeAttachment)
                likeString.append(NSAttributedString(string: " \(post.reactions.likes)"))
                self?.likesLabel.attributedText = likeString

                let dislikeAttachment = NSTextAttachment()
                dislikeAttachment.image = UIImage(systemName: "hand.thumbsdown.fill")?.withRenderingMode(.alwaysTemplate)
                dislikeAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                let dislikeString = NSMutableAttributedString(attachment: dislikeAttachment)
                dislikeString.append(NSAttributedString(string: " \(post.reactions.dislikes)"))
                self?.dislikesLabel.attributedText = dislikeString

                let viewAttachment = NSTextAttachment()
                viewAttachment.image = UIImage(systemName: "book.fill")?.withRenderingMode(.alwaysTemplate)
                viewAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                let viewString = NSMutableAttributedString(attachment: viewAttachment)
                viewString.append(NSAttributedString(string: " \(post.views)"))
                self?.viewsLabel.attributedText = viewString

                self?.navigationItem.title = "User \(post.userId)"
                self?.tagCarousel.setTags(post.tags)
            
            }
            .store(in: &cancellables)
        
        
    }
    
}
