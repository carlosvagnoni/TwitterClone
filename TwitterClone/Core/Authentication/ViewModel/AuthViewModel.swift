//
//  AuthViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/9/23.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
}
