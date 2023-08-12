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
    
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    
    init(user: User) {
        self.profileViewModel = ProfileViewModel(user: user)
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
        .toolbar(.hidden)
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
                    .foregroundColor(.primary)
                    .padding(6)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.75))
            }
            
            Button {
                
                
            } label: {
                Text(profileViewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 37)
                    .foregroundColor(.primary)
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
            
            Text("Keep pushing the limits")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 15) {
                HStack(spacing: 5) {
                    
                    Image(systemName: "mappin.and.ellipse")
                    
                    Text("Mónaco, Mónaco")
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "link")
                    
                    Text("www.formula1.com")
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
                        .foregroundColor(selectedFilter == item ? .primary : .gray)
                    
                    if selectedFilter == item {
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                    } else {
                        
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    self.selectedFilter = item
                    switch item {
                    case .likes:
                        profileViewModel.fetchLikedTweets()
                    case .tweets:
                        profileViewModel.fetchUserTweets()
                    case .replies:
                        profileViewModel.fetchRetweetedTweets()
                    }
                }
                .onReceive(InteractionNotifier.shared.tweetDeleted) { _ in
                    profileViewModel.fetchUserTweets()
                    profileViewModel.fetchLikedTweets()
                    profileViewModel.fetchRetweetedTweets()
                }
                .onReceive(InteractionNotifier.shared.retweetInteractionStatus) { _ in
                    profileViewModel.fetchUserTweets()
                    profileViewModel.fetchLikedTweets()
                    profileViewModel.fetchRetweetedTweets()
                }
                .onReceive(InteractionNotifier.shared.likeInteractionStatus) { _ in
                    profileViewModel.fetchUserTweets()
                    profileViewModel.fetchLikedTweets()
                    profileViewModel.fetchRetweetedTweets()
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
    
    var tweetsView: some View {
        
        VStack {
            if profileViewModel.isLoading {
                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(profileViewModel.tweets(forFilter: self.selectedFilter)) { tweet in
                            
                            if self.selectedFilter == .replies {
                                TweetRowView(tweet: tweet, isRetweet: true, retweetedUserFullname: profileViewModel.user.fullname)
                            } else {
                                TweetRowView(tweet: tweet)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {        
        ProfileView(user: User.MOCK_USER)
    }
}
