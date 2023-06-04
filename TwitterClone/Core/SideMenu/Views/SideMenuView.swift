//
//  SideMenuView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 12) {
                
                Circle()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Daniel Ricciardo")
                        .font(.subheadline).bold()
                    
                    Text("@thehoneybadger")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                
                UserStatsView()
                       
            }
            
            Divider()
                .padding(.vertical)
            
            ForEach(SideMenuViewModel.allCases, id: \.rawValue) { option in
                
                if option == .profile {
                    
                    NavigationLink {
                        
                        ProfileView()
                        
                    } label: {
                        
                        SideMenuRowView(sideMenuViewModel: option)
                        
                    }
                    
                } else if option == .logout {
                    
                    Button {
                        
                        print("Logout")
                        
                    } label: {
                        
                        SideMenuRowView(sideMenuViewModel: option)
                            .foregroundColor(.black)
                        
                    }
                    
                } else {
                    
                    SideMenuRowView(sideMenuViewModel: option)
                    
                }
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        
    }
}

struct SideMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SideMenuView()
        
    }
}
