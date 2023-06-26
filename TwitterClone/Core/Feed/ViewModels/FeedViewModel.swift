//
//  FeedViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    @Published var isLoading = false
    
    let tweetService = TweetService()
    let userService = UserService()
    
    init() {
        
        fetchTweets()
        
    }
    
    
    func fetchTweets() {
        
        isLoading = true
        
        tweetService.fetchTweets { tweets in
            
            DispatchQueue.main.async {
                
                self.tweets = tweets
                
                self.isLoading = false
                
            }
            
        }
                
    }
    
}
