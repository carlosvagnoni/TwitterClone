//
//  UserStatsView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI

struct UserStatsView: View {
    
    var body: some View {
        
        HStack(spacing: 15) {
            HStack(spacing: 5) {
                
                Text("10")
                    .bold()
                
                Text("Following")
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 5) {
                Text("1.5M")
                    .bold()
                
                Text("Followers")
                    .foregroundColor(.gray)
            }
        }
        .font(.caption)
    }
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView()        
    }
}
