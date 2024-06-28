//
//  RepositoryViewModel.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import Foundation
import Combine
import CoreData

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRepositories(query: String, page: Int) {
        // Fetch repositories from local storage
        let savedRepositories = CoreDataManager.shared.fetchSavedRepositories()
        repositories = savedRepositories
        
        // Start loading indicator
        isLoading = true
        
        // Perform network request
        NetworkManager.shared.searchRepositories(query: query, page: page)
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] repositories in
                guard let self = self else { return }
                
                // Save fresh repositories to Core Data
                CoreDataManager.shared.saveRepositories(repositories)
                
                // Update view model with fresh data
                self.repositories = repositories
            })
            .store(in: &cancellables)
    }
}

