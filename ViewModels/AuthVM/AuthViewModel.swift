//
//  AuthViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import Combine

class AuthViewModel{
    
    @Published var loginResponse: LoginResponse?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        authService.login(username: username, password: password)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    print("LogIn Successfully")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.loginResponse = response
            }
            .store(in: &cancellables)
    }
    
    func fetchProtectedData() {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
              let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            errorMessage = "Token not found, please login again."
            return
        }
        
        var request = URLRequest(url: URL(string: "https://dummyjson.com/protected_endpoint")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.performRequestWithAutoRefresh(request,authService: AuthService(),refreshToken: refreshToken)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }, receiveValue: { (response: LoginResponse) in
            self.loginResponse = response
        })
        .store(in: &cancellables)
    }
}
