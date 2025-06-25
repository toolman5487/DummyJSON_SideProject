//
//  CommentViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/25.
//

import Foundation
import Combine

class CommentViewModel: ObservableObject {
    
    @Published var comments: [CommentModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?

    private let service: CommentServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: CommentServiceProtocol = CommentService()) {
        self.service = service
    }


    func fetchComments(for postId: Int) {
        isLoading = true
        error = nil
        service.fetchComments(for: postId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            } receiveValue: { [weak self] comments in
                self?.comments = comments
            }
            .store(in: &cancellables)
    }
}
