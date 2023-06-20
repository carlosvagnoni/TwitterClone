//
//  TweetRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/19/23.
//

import Foundation

class TweetRowViewModel: ObservableObject {
    
    private let tweetService = TweetService()
    
    @Published var tweet: Tweet
    
    init(tweet: Tweet) {
        
        self.tweet = tweet
        
        checkIfUserLikedTweet()
        
    }
    
    func likeTweet() {
        
        tweetService.likeTweet(tweet) {
            
            self.tweet.didLike = true
            
        }
        
    }
    
    func unlikeTweet() {
        
        tweetService.unlikeTweet(tweet) {
            
            self.tweet.didLike = false
            
        }
        
    }
    
    func checkIfUserLikedTweet() {
        
        tweetService.checkIfUserLikedTweet(tweet) { didLike in
            if didLike {
                
                self.tweet.didLike = true
                
            }
        }
        
    }
    
}
