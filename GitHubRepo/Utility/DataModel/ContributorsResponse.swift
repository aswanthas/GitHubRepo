//
//  ContributorsResponse.swift
//  GitHubRepo
//
//  Created by Aswanth K on 29/06/24.
//

import Foundation

struct ContributorsResponse: Codable, Identifiable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let contributions: Int
    
    enum CodingKeys: String, CodingKey {
        case login, id, nodeId = "node_id", avatarUrl = "avatar_url", gravatarId = "gravatar_id", url, htmlUrl = "html_url", followersUrl = "followers_url", followingUrl = "following_url", gistsUrl = "gists_url", starredUrl = "starred_url", subscriptionsUrl = "subscriptions_url", organizationsUrl = "organizations_url", reposUrl = "repos_url", eventsUrl = "events_url", receivedEventsUrl = "received_events_url", type, siteAdmin = "site_admin", contributions
    }
}
