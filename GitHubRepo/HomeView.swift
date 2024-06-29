//
//  ContentView.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = RepositoryViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TextField("Search Repositories", text: $viewModel.query, onCommit: {
                        viewModel.page = 1 // Reset to first page for a new search
                        viewModel.fetchRepositories(query: viewModel.query, page: viewModel.page)
                    })
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        if viewModel.repositories.isEmpty {
                            Spacer()
                        } else {
                            List {
                                ForEach(viewModel.repositories) { repo in
                                    NavigationLink(destination: RepoDetailsView(repository: repo)) {
                                        RepositoryRowView(repository: repo)
                                            .onAppear {
                                                // Check if this is the last item
                                                if viewModel.repositories.isLastItem(repo) {
                                                    // Trigger loading the next page
                                                    viewModel.loadNextPage()
                                                }
                                            }
                                    }
                                }
                                
                                if viewModel.isLoading && !viewModel.repositories.isEmpty {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                }
                            }
                        }
                }
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView()
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                // Load saved data initially
                viewModel.fetchSavedRepositories()
            }
            .alert(isPresented: $viewModel.showAlert) { // Display the alert
                        Alert(
                            title: Text("Warning"),
                            message: Text(viewModel.errorMessage ?? "Please try again"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

        }
    }
}
