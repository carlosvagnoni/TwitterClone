//
//  SideMenuView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 12) {
                    
//                    AsyncImage( url: URL(string: user.profilePhotoUrl) )
//                    { image in
//
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .clipShape(Circle())
//
//                    } placeholder: {
//
//                        ZStack {
//
//                            Circle()
//                                .foregroundColor(Color(.systemGray4))
//
//                            ProgressView()
//
//                        }
//
//                    }
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
                            
                            authViewModel.signOut()
                            
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
}

struct SideMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SideMenuView()
            .environmentObject(AuthViewModel())
        
    }
}
