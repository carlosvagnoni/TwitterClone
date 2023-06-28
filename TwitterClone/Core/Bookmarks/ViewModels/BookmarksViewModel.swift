//
//  BookmarksViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/28/23.
//

import Foundation

class BookmarksViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    @Published var isLoading = false
    
    let tweetService = TweetService()
    
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
