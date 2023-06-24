//
//  FeedViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    
    let tweetService = TweetService()
    let userService = UserService()
    
    init() {
        
        fetchTweets()
        
    }
    
    
    func fetchTweets() {
        
        tweetService.fetchTweets { tweets in
            
            self.tweets = tweets            
            
        }
                
    }
    
}
