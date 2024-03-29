//
//  SideMenuView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    KFImage(URL(string: user.profilePhotoUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(user.fullname)
                            .font(.subheadline).bold()
                        
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    UserStatsView()
                }
                
                Divider()
                    .background(Color("dividerColor"))
                    .padding(.vertical)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue) { option in
                    
                    if option == .profile {
                        NavigationLink {
                            ProfileView(user: user)
                        } label: {
                            SideMenuRowView(sideMenuViewModel: option)
                        }
                    } else if option == .logout {
                        Button {
                            Task {
                                authViewModel.signOut()
                            }
                            
                        } label: {
                            SideMenuRowView(sideMenuViewModel: option)
                                .foregroundColor(.primary)
                        }
                        
                    } else if option == .bookmarks {
                        
                        NavigationLink {
                            BookmarksView()
                        } label: {
                            SideMenuRowView(sideMenuViewModel: option)
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
}
