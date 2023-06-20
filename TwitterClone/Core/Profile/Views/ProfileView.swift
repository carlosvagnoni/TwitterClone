//
//  ProfileView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var profileViewModel: ProfileViewMpdel
    
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    
    @Namespace var animation
    
    init(user: User) {
        
        self.profileViewModel = ProfileViewMpdel(user: user)
        
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            headerView
            
            actionButtons
            
            userInfoDeatils
            
            tweetFilterBar
            
            tweetsView
            
            Spacer()
            
        }
        .navigationBarHidden(true)
    }
}

extension ProfileView {

    var headerView: some View {

        ZStack(alignment: .bottomLeading) {

            Color(.systemBlue)
                .ignoresSafeArea()

            VStack {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "arrow.left.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)

                }
                .padding(.top, 20)

//                AsyncImage( url: URL(string: user.profilePhotoUrl) )
//                { image in
//
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .clipShape(Circle())
//
//                } placeholder: {
//
//                    ZStack {
//
//                        Circle()
//                            .foregroundColor(Color(.systemGray4))
//
//                        ProgressView()
//
//                    }
//
//
//                }
                KFImage(URL(string: profileViewModel.user.profilePhotoUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72, height: 72)
                .offset(x: 16, y: 36)

            }

        }
        .frame(height: 96)
        .padding(.bottom, 12)

    }
    
    var actionButtons: some View {
        
        HStack(spacing: 12) {
            
            Spacer()
            
            Button {
                
                print("Turn notifications on")
                
            } label: {
                
                Image(systemName: "bell.badge")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(6)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.75))
                    
            }
            
            Button {
                
                
                
            } label: {
                
                Text("Edit Profile")
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 37)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
                
            }

        }
        .padding(.trailing, 12)
        
    }
    
    var userInfoDeatils: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                
                Text(profileViewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
                
            }
            
            Text("@\(profileViewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("In the end, you have to just pull the trigger.")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 15) {
                
                HStack(spacing: 5) {
                    
                    Image(systemName: "mappin.and.ellipse")
                    
                    Text("Perth, Australia")
                    
                }
                
                HStack(spacing: 5) {
                    
                    Image(systemName: "link")
                    
                    Text("www.danielricciardo.com")
                    
                }
                
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            UserStatsView()
                .padding(.vertical, 10)
            
        }
        .padding(.horizontal, 12)
        
    }
    
    var tweetFilterBar: some View {
        
        HStack {
            
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue) { item in
                
                VStack {
                    
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .bold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                    
                    if selectedFilter == item {
                        
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                        
                    } else {
                        
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                        
                    }
                    
                    
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        
                        self.selectedFilter = item
                        
                    }
                }
                
            }
            
        }
        .overlay(Divider().offset(x: 0, y: 16))
        
    }
    
    var tweetsView: some View {
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(profileViewModel.tweets(forFilter: self.selectedFilter)) { tweet in
                    
                    TweetRowView(tweet: tweet)
                    
                }
                
            }
            
        }
        
    }

}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ProfileView(user: User(username: "thehoneybadger", fullname: "Daniel Ricciardo", profilePhotoUrl: "", email: ""))
    }
}
