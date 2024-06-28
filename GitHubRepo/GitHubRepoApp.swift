//
//  GitHubRepoApp.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import SwiftUI

@main
struct GitHubRepoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Register the custom transformer
    override init() {
        super.init()
        ValueTransformer.setValueTransformer(UserTransformer(), forName: NSValueTransformerName("UserTransformer"))
    }

    // Other AppDelegate methods...
}
