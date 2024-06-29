//
//  HelperExtension.swift
//  GitHubRepo
//
//  Created by Aswanth K on 29/06/24.
//

import Foundation
// Extension to check if the item is the last in the array
extension Array where Element: Identifiable {
    func isLastItem(_ item: Element) -> Bool {
        guard !isEmpty else { return false }
        return item.id == last?.id
    }
}
