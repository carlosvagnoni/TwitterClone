//
//  MessagesView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct MessagesView: View {
    
    @State private var showUserListView = false
    
    @EnvironmentObject var messagesViewModel : MessagesViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
 
            if messagesViewModel.isLoading {
                
                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
    
                }
            else {
                    
//                    ScrollView {
                        
//                        LazyVStack {
//
//                            ForEach(Array(feedViewModel.tweetsData.enumerated()), id: \.offset) { index, tweetData in
//                                TweetRowView(tweet: tweetData.tweet, isRetweet: tweetData.isRetweet, retweetedUserFullname: tweetData.retweetedUserFullname)
//                            }
//                        }
                        
                    }
           
                }
            
            Button {
                
                showUserListView = true
                
            } label: {
                
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .padding()
                
            }
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $showUserListView) {
                
                NewTweetView()
                
                
            }
            
        }
//        .onAppear() {
//
//            feedViewModel.fetchTweets()
//            notificationsViewModel.fetchNotifications()
//
//        }
//        .onReceive(InteractionNotifier.shared.tweetDeleted) { _ in
//            feedViewModel.fetchTweets()
//                }
//        .onReceive(InteractionNotifier.shared.retweetInteractionStatus) { _ in
//            feedViewModel.fetchTweets()
//                }
        
        
    
}


struct MessagesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MessagesView()
            .environmentObject(MessagesViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(NotificationsViewModel())
        
    }
}
