//
//  MessageRecipientListViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 7/21/23.
//

import Firebase

class MessageRecipientListViewModel: ObservableObject {
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
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        userService.fetchUsers { users in
            self.users = users.filter { $0.id != currentUserID }
        }
    }
}
