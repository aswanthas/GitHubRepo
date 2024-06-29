//
//  RepoDetailsViewModel.swift
//  GitHubRepo
//
//  Created by Aswanth K on 29/06/24.
//

import Foundation
import Combine

class RepoDetailsViewModel: ObservableObject {
    @Published var selctedRepoContributors: [ContributorsResponse] = []
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    private var cancellables = Set<AnyCancellable>()

    func getContributors(_ url: String) {
        let api = GitHubAPI.getContributors(username: url)
        NetworkManager.shared.fetchData(api: api)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }, receiveValue: { [weak self] (respone: [ContributorsResponse]) in
                guard let self = self else { return }
                self.selctedRepoContributors = respone
            })
            .store(in: &cancellables)
    }
}
