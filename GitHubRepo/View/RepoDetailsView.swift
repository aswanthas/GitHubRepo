//
//  RepoDetailsView.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

struct RepoDetailsView: View {
    @StateObject var viewModel = RepoDetailsViewModel()
    let repository: Repository
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    AsyncImage(url: URL(string: repository.owner.avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }
                    Text(repository.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Owner")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Text(repository.owner.login)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                    }
                    .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Text(repository.description ?? "No description available")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, 8)
                    
                    Button(action: {
                        if let url = URL(string: repository.htmlUrl) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Project Link")
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    if viewModel.selctedRepoContributors.isEmpty {
                        Text("No contributors found.")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .padding(.top, 16)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contributors")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            ForEach(viewModel.selctedRepoContributors, id: \.id) { contributor in
                                HStack {
                                    AsyncImage(url: URL(string: contributor.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .clipShape(.circle)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 30, height: 30)
                                    }
                                    Text(contributor.login)
                                        .font(.system(size: 15, weight: .regular, design: .rounded))
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .frame(alignment: .leading)
                .padding()
            }
            .frame(width: proxy.size.width, alignment: .leading)
        }
        .navigationTitle("Repository Details")
        .onAppear {
            viewModel.getContributors(repository.contributorsUrl)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text(viewModel.errorMessage ?? "An unexpected error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

