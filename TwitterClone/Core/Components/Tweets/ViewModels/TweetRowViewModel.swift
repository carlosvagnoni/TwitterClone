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
        checkIfUserRetweetedTweet()
        checkIfUserBookmarkedTweet()
        
    }
    
    func fetchUserForTweet() {
        
        userService.fetchUser(withUid: tweet.uid) { user in
            
            DispatchQueue.main.async {
                
                self.tweet.user = user
                
            }
        }
    }
    
    func likeTweet() {
        
        tweetService.likeTweet(tweet) { updatedLikes in
            
            self.tweet.likes = updatedLikes
            
            self.tweet.didLike = true
            
            InteractionNotifier.shared.likeInteractionStatus.send()
            
            
        }
        
        
        
    }
    
    func unlikeTweet() {
        
        tweetService.unlikeTweet(tweet) { updatedLikes in
            
            self.tweet.likes = updatedLikes
            
            self.tweet.didLike = false

            InteractionNotifier.shared.likeInteractionStatus.send()
        }
    }
    
    
    
    func checkIfUserLikedTweet() {

        tweetService.checkIfUserLikedTweet(tweet) { didLike in
            
            if didLike {
                
                self.tweet.didLike = true
                
            }
        }

    }
    
    func retweetTweet(completion: @escaping() -> Void) {
        
        tweetService.retweetTweet(tweet) { updatedRetweetCount in
            
            self.tweet.retweetCount = updatedRetweetCount
            
            self.tweet.didRetweet = true
            
            completion()
        }
        
        
        
    }
    
    func unretweetTweet(completion: @escaping() -> Void) {
        
        tweetService.unretweetTweet(tweet) { updatedRetweetCount in
            
            self.tweet.retweetCount = updatedRetweetCount
            
            self.tweet.didRetweet = false
            
            completion()
        }
    }
    
    
    
    func checkIfUserRetweetedTweet() {

        tweetService.checkIfUserRetweetedTweet(tweet) { didRetweet in
            
            if didRetweet {
                
                self.tweet.didRetweet = true
                
            }
        }

    }
    
    func bookmarkTweet() {
        
        tweetService.bookmarkTweet(tweet) { updatedBookmarkCount in
            
            self.tweet.bookmarkCount = updatedBookmarkCount
            
            self.tweet.didBookmark = true
            
            InteractionNotifier.shared.bookmarkInteractionStatus.send()
        }
        
        
        
    }
    
    func unbookmarkTweet() {
        
        tweetService.unbookmarkTweet(tweet) { updatedBookmarkCount in
            
            self.tweet.bookmarkCount = updatedBookmarkCount
            
            self.tweet.didBookmark = false

            InteractionNotifier.shared.bookmarkInteractionStatus.send()
        }
    }
    
    
    
    func checkIfUserBookmarkedTweet() {

        tweetService.checkIfUserBookmarkedTweet(tweet) { didBookmark in
            
            if didBookmark {
                
                self.tweet.didBookmark = true
                
            }
        }

    }
    
}
