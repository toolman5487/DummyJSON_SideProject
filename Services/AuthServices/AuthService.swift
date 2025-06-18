//
//  AuthService.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation
import Combine

protocol AuthServiceProtocol{
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error>
    func fetchAuthUser(token: String) -> AnyPublisher<UserModel, Error>
}

class AuthService: AuthServiceProtocol {
    
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        let url = APIConfig.baseURL.appendingPathComponent("auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password)
        request.httpBody = try? JSONEncoder().encode(body)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                print("HTTP status code:", response?.statusCode ?? -1)
                let dataStr = String(data: output.data, encoding: .utf8) ?? "(empty)"
                print("Response data string:", dataStr)
                return output.data
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchAuthUser(token: String) -> AnyPublisher<UserModel, Error> {
        let url = APIConfig.baseURL.appendingPathComponent("auth/me")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func refreshToken(_ refreshToken: String) -> AnyPublisher<LoginResponse, Error> {
        let url = APIConfig.baseURL.appendingPathComponent("auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken, "expiresInMins": 30] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
