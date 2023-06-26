//
//  MainTabViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/25/23.
//

import Foundation

class MainTabViewModel: ObservableObject {
    
    func titleForSelectedIndex(_ index: Int) -> String {
        
            switch index {
                
            case 0:
                return "Home"
                
            case 1:
                return "Explore"
                
            case 2:
                return "Notifications"
                
            case 3:
                return "Messages"
                
            default:
                return "Home"
                
            }
        }
}

