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
    @Published var showAlert: Bool = false
    @Published var page = 1
    @Published var query = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSavedRepositories()
    }
    
    func fetchSavedRepositories() {
        let savedRepositories = CoreDataManager.shared.fetchSavedRepositories()
        self.repositories = savedRepositories
    }
    
    func fetchRepositories(query: String, page: Int) {
        guard !query.isEmpty else {
            self.errorMessage = "Please search with a word"
            self.showAlert = true
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        let api = GitHubAPI.searchRepositories(query: query, page: page)
        NetworkManager.shared.fetchData(api: api)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }, receiveValue: { [weak self] (response: SearchResponse) in
                guard let self = self else { return }
                
                let newRepositories = response.items
                
                if page == 1 {
                    self.repositories = newRepositories
                } else {
                    self.repositories.append(contentsOf: newRepositories)
                }
                
                // Save the first 15 items to Core Data
                if self.repositories.count <= 15 {
                    let first15 = Array(self.repositories.prefix(15))
                    CoreDataManager.shared.deleteAllRepositories() // Clear old data
                    CoreDataManager.shared.saveRepositories(first15)
                    debugPrint("Saved the first 15 repositories to Core Data.")
                } else if page > 1 && self.repositories.count > 15 && self.repositories.count <= (page * 10) {
                    let first15 = Array(self.repositories.prefix(15))
                    CoreDataManager.shared.deleteAllRepositories()
                    CoreDataManager.shared.saveRepositories(first15)
                    debugPrint("Saved the first 15 repositories to Core Data after pagination.")
                }
            })
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        page += 1
        fetchRepositories(query: query, page: page)
    }
}

