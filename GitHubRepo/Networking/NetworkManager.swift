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
    
    func fetchData<T: Decodable>(api: GitHubAPI) -> AnyPublisher<T, Error> {
        guard let url = URL(string: api.description) else {
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
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

public enum GitHubAPI {
    case searchRepositories(query: String, page: Int)
    case getContributors(username: String)
    // Add more cases as needed
}

extension GitHubAPI: CustomStringConvertible {
    public var description: String {
        switch self {
        case .searchRepositories(let query, let page):
            return "https://api.github.com/search/repositories?q=\(query)&per_page=10&page=\(page)"
        case .getContributors(let url):
            return url
        }
    }
}

