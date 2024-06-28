//
//  NetworkManager.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func searchRepositories(query: String, page: Int) -> AnyPublisher<[Repository], Error> {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&per_page=10&page=\(page)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        print("URLRequest: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
            })
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map { $0.items }
            .eraseToAnyPublisher()
    }
}
