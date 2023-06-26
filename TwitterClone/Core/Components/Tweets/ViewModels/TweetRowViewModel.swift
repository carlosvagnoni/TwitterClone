//
//  TweetRowViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/19/23.
//

import Foundation

class TweetRowViewModel: ObservableObject {
    
    private let tweetService = TweetService()
    private let userService = UserService()
    
    @Published var tweet: Tweet
    
    init(tweet: Tweet) {
        
        self.tweet = tweet
        
        fetchUserForTweet()
        
        checkIfUserLikedTweet()
        
    }
    
    func fetchUserForTweet() {
        
        userService.fetchUser(withUid: tweet.uid) { user in
            
            DispatchQueue.main.async {
                
                self.tweet.user = user
                
            }
        }
    }
    
    func likeTweet() {
        
        tweetService.likeTweet(tweet) {
            
            guard let tweetId = self.tweet.id else { return }
            
            self.tweetService.fetchTweet(withId: tweetId) { updatedTweet in
                
                self.tweet = updatedTweet
                
                self.tweet.didLike = true
                
                self.fetchUserForTweet()
                
            }
        }
    }

    func unlikeTweet() {
        
        tweetService.unlikeTweet(tweet) {
            
            guard let tweetId = self.tweet.id else { return }
            
            self.tweetService.fetchTweet(withId: tweetId) { updatedTweet in
                
                self.tweet = updatedTweet
                
                self.tweet.didLike = false
                
                self.fetchUserForTweet()
                
            }
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
