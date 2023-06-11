//
//  TwitterCloneApp.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI
import Firebase

@main
struct TwitterCloneApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        
        WindowGroup {
                
            NavigationView {
                
                ContentView()
                        
            }
            .environmentObject(authViewModel)
                   
        }
    }
}
