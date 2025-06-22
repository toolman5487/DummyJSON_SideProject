//
//  PostDetailViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
    
    let postId: Int
    private let service: PostDetailServiceProtocol
    @Published private(set) var postDetail: PostDetailModel?
    @Published var isLoading = false
    @Published var error: Error?
    private var cancellables = Set<AnyCancellable>()

    init(postId: Int, service: PostDetailServiceProtocol) {
        self.postId = postId
        self.service = service
    }

    func fetchDetail() {
        isLoading = true
        error = nil

        service.fetchPostDetail(id: postId)
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
            } receiveValue: { [weak self] detail in
                self?.postDetail = detail
            }
            .store(in: &cancellables)
    }
}
