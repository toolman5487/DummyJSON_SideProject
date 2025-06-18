//
//  UsersViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import Combine

class UsersViewModel{
    
    @Published var user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func fetchUser(token: String) {
        isLoading = true
        errorMessage = nil
        authService.fetchAuthUser(token: token)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("User GET")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
}
