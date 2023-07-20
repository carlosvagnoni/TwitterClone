//
//  FeedView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI

struct FeedView: View {
    
    @State private var showNewTweetView = false
    
    @EnvironmentObject var feedViewModel : FeedViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
 
            if feedViewModel.isLoading {
                
                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(Array(feedViewModel.tweetsData.enumerated()), id: \.offset) { index, tweetData in
                                TweetRowView(tweet: tweetData.tweet, isRetweet: tweetData.isRetweet, retweetedUserFullname: tweetData.retweetedUserFullname)
                            }
                        }
                        
                    }
           
                }
            
            Button {
                
                showNewTweetView = true
                
            } label: {
                
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 28, height: 28)
                    .padding()
                
            }
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $showNewTweetView) {
                
                NewTweetView()
                
                
            }
            
        }
        .onAppear() {
            
            feedViewModel.fetchTweets()
            notificationsViewModel.fetchNotifications()
            
        }
        .onReceive(InteractionNotifier.shared.tweetDeleted) { _ in
            feedViewModel.fetchTweets()
                }
        .onReceive(InteractionNotifier.shared.retweetInteractionStatus) { _ in
            feedViewModel.fetchTweets()
                }
        
        
    }
}

struct FeedView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FeedView()
            .environmentObject(FeedViewModel())
        
    }
}
