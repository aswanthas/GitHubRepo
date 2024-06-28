//
//  SearchResponse.swift
//  GitHubRepo
//
//  Created by Aswanth K on 28/06/24.
//

import Foundation

// Model for search response

struct SearchResponse: Codable {
    let items: [Repository]
}

// Model for repository
struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
    let htmlUrl: String
    let description: String?
    let contributorsUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name, owner, description
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case contributorsUrl = "contributors_url"
    }
}

// Model for user (repository owner or contributor)
struct User: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String

    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
// Wrapper class to store User in Core Data
@objc(UserWrapper)
class UserWrapper: NSObject, NSCoding {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(user.id, forKey: "id")
        coder.encode(user.login, forKey: "login")
        coder.encode(user.avatarUrl, forKey: "avatarUrl")
        coder.encode(user.htmlUrl, forKey: "htmlUrl")
    }
    
    required init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: "id")
        guard let login = coder.decodeObject(forKey: "login") as? String,
              let avatarUrl = coder.decodeObject(forKey: "avatarUrl") as? String,
              let htmlUrl = coder.decodeObject(forKey: "htmlUrl") as? String else {
            return nil
        }
        self.user = User(id: id, login: login, avatarUrl: avatarUrl, htmlUrl: htmlUrl)
    }
}

@objc(UserTransformer)
class UserTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let user = value as? User else { return nil }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            return data
        } catch {
            print("Failed to encode User: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            print("Failed to decode User: \(error)")
            return nil
        }
    }
}
