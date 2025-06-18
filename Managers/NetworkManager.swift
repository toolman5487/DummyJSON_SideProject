//
//  NetworkManager.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case unauthorized
    case other(Error)

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized):
            return true
        case (.other, .other):
            return true 
        default:
            return false
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    private var cancellables = Set<AnyCancellable>()
    
    func request<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if response.statusCode == 401 {
                    throw NetworkError.unauthorized
                }
                guard 200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func performRequestWithAutoRefresh<T: Decodable>(_ urlRequest: URLRequest,
                                                     authService: AuthService,
                                                     refreshToken: String) -> AnyPublisher<T, Error> {
        return NetworkManager.shared.request(urlRequest)
            .catch { error -> AnyPublisher<T, Error> in
                if let netError = error as? NetworkError, netError == .unauthorized {
                    return authService.refreshToken(refreshToken)
                        .flatMap { loginResponse -> AnyPublisher<T, Error> in
                            UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                            
                            var newRequest = urlRequest
                            newRequest.setValue("Bearer \(loginResponse.accessToken)", forHTTPHeaderField: "Authorization")
                            return NetworkManager.shared.request(newRequest)
                        }
                        .eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
