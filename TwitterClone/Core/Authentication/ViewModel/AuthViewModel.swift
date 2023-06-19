//
//  AuthViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/9/23.
//
import Firebase
import SwiftUI


class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var tempUserSession: FirebaseAuth.User?
    private let userService = UserService()
    
    init() {
        
        self.userSession = Auth.auth().currentUser
        
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
                
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            self.fetchUser()
            
        }
        
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            
            let data = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    
                    completion(true)
                    
                }
        }
    }
    

    func signOut() {
        
            do {
                
                try Auth.auth().signOut()
                
                self.userSession = nil
                
            } catch let signOutError as NSError {
                
                print("Error signing out: %@", signOutError)
                
            }
        }
    
    func uploadProfilePhoto(_ image: UIImage) {
        
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profilePhotoUrl in
            
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profilePhotoUrl": profilePhotoUrl]) { _ in
                    
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                    
                }
        }
        
    }
    
    func fetchUser() {
        
        guard let uid = self.userSession?.uid else { return }
        
        userService.fetchUser(withUid: uid) { user in
            
            self.currentUser = user
            
        }
        
    }
}
