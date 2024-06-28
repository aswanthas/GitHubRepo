//
//  RepositoryRowView.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
            Text(repository.description ?? "No description available")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
