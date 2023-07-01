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
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
 
            if feedViewModel.isLoading {
                
                VStack {
                    
                    Spacer()
                    
                    
                    
                    HStack {
                        
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(2)
                        
                        Spacer()
                        
                    }
                    
                    
                    
                    Spacer()
                    
                }
    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(Array(feedViewModel.tweets.enumerated()), id: \.offset) { index, tweet in
                                
                                TweetRowView(tweet: tweet)
                                
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
            
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FeedView()
            .environmentObject(FeedViewModel())
        
    }
}
