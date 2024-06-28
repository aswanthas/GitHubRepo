//
//  ContentView.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RepositoryViewModel()
    @State private var query = ""
    @State private var page = 1
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Repositories", text: $query, onCommit: {
                    viewModel.fetchRepositories(query: query, page: page)
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.repositories) { repo in
                        NavigationLink(destination: RepoDetailsView(repository: repo)) {
                            RepositoryRowView(repository: repo)
                        }
                    }
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                viewModel.fetchRepositories(query: "Swift", page: page) // Initial fetch
            }
        }
    }
}
