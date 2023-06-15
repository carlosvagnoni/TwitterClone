//
//  ExploreViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

class ExploreViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    let userService = UserService()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        
        userService.fetchUsers { users in
            
            self.users = users
            
        }
    }
}
