//
//  BookmarksViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/28/23.
//

import Foundation

class BookmarksViewModel: ObservableObject {
    @Published var bookmarkedTweets = [Tweet]()
    @Published var isLoading = false
    
    let tweetService = TweetService()
    
    init() {
        
        fetchBookmarkedTweets()
        
    }
    
    
    func fetchBookmarkedTweets() {
        
        isLoading = true
        
        tweetService.fetchBookmarkedTweets { bookmarkedTweets in
            
            DispatchQueue.main.async {
                
                self.bookmarkedTweets = bookmarkedTweets
                
                self.isLoading = false
                
            }
        }
                
    }
    
}
