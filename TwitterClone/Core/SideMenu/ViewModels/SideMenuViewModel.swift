//
//  SideMenuViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

enum SideMenuViewModel: Int, CaseIterable {
    
    case profile
    case verification
    case bookmarks
    case logout
    
    var title: String {
        
        switch self {
            
        case .profile: return "Profile"
        case .verification: return "Blue"
        case .bookmarks: return "Bookmarks"
        case .logout: return "Logout"
            
        }
        
    }
    
    var imageName: String {
        
        switch self {
            
        case .profile: return "person"
        case .verification: return "checkmark.seal"
        case .bookmarks: return "bookmark"
        case .logout: return "arrow.left.square"
            
        }
        
    }
    
}
