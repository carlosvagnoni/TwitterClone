//
//  ExploreViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

class ExploreViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var searchText = ""
    
    let userService = UserService()
    
    init() {
        fetchUsers()
    }
    
    var searchableUsers: [User] {
        let lowercasedQuery = searchText.lowercased()
        
        return users.filter({
            $0.username.lowercased().contains(lowercasedQuery) || $0.fullname.lowercased().contains(lowercasedQuery)
        })
    }
    
    func fetchUsers() {
        userService.fetchUsers { users in
            
            self.users = users
        }
    }
}
