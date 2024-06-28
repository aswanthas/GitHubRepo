//
//  RepoDetailsView.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

struct RepoDetailsView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: repository.owner.avatarUrl)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } placeholder: {
                ProgressView()
            }
            
            Text(repository.name)
                .font(.title)
            
            Text("Owner: \(repository.owner.login)")
                .font(.subheadline)
            
            Text(repository.description ?? "No description available")
                .font(.body)
            
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
            
            // Fetch and display contributors here
            
            Spacer()
        }
        .padding()
        .navigationTitle("Repository Details")
    }
}

