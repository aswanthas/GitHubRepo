//
//  CoreDataManager.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "RepositoryEntity")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data stack: \(error)")
            }
        }
    }
    
    func saveRepositories(_ repositories: [Repository]) {
        let context = persistentContainer.viewContext
        repositories.forEach { repository in
            let repoEntity = RepositoryEntity(context: context)
            repoEntity.id = Int64(repository.id)
            repoEntity.name = repository.name
            repoEntity.fullName = repository.fullName
            repoEntity.ownerLogin = repository.owner.login
            repoEntity.ownerAvatarUrl = repository.owner.avatarUrl
            repoEntity.htmlUrl = repository.htmlUrl
            repoEntity.repositoryDescription = repository.description
            repoEntity.contributorsUrl = repository.contributorsUrl
            repoEntity.owner = UserWrapper(user: repository.owner)
        }
        
        do {
            try context.save()
        } catch {
            debugPrint("Error saving repositories: \(error)")
        }
    }
    
    func fetchSavedRepositories() -> [Repository] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        
        do {
            let repoEntities = try context.fetch(fetchRequest)
            var repositories: [Repository] = []
            
            for entity in repoEntities {
                // Attempt to unwrap the owner from UserWrapper
                guard let ownerWrapper = entity.owner as? UserWrapper else {
                    debugPrint("Failed to decode owner for repository \(entity.name ?? "")")
                    continue
                }
                let owner = ownerWrapper.user
                
                let repository = Repository(
                    id: Int(entity.id),
                    name: entity.name ?? "",
                    fullName: entity.fullName ?? "",
                    owner: User(
                        id: owner.id,
                        login: owner.login,
                        avatarUrl: owner.avatarUrl,
                        htmlUrl: owner.htmlUrl // Use the stored htmlUrl
                    ),
                    htmlUrl: entity.htmlUrl ?? "",
                    description: entity.repositoryDescription ?? "",
                    contributorsUrl: entity.contributorsUrl ?? ""
                )
                repositories.append(repository)
            }
            
            return repositories
        } catch {
            debugPrint("Error fetching saved repositories: \(error)")
            return [] // Return an empty array in case of any errors
        }
    }
    // New method to delete all repositories
        func deleteAllRepositories() {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RepositoryEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save() // Save context to reflect changes
            } catch {
                debugPrint("Error deleting all repositories: \(error)")
            }
        }
}
