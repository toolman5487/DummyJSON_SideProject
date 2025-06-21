//
//  PostViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/21.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    @Published private(set) var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let postService: PostServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private let pageSize = 30
    private var canLoadMore = true
    
    init(postService: PostServiceProtocol) {
        self.postService = postService
    }
    
    func fetchInitialPosts() {
        posts = []
        currentPage = 0
        canLoadMore = true
        fetchPosts()
    }
    
    func fetchNextPage() {
        guard !isLoading && canLoadMore else { return }
        currentPage += 1
        fetchPosts()
    }
    
    private func fetchPosts() {
        isLoading = true
        let skip = currentPage * pageSize
        
        postService.fetchPosts(limit: pageSize, skip: skip)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let err):
                    self.error = err
                case .finished:
                    break
                }
            } receiveValue: { [weak self] model in
                guard let self = self else { return }
                if model.posts.isEmpty { self.canLoadMore = false }
                self.posts.append(contentsOf: model.posts)
            }
            .store(in: &cancellables)
    }
}
