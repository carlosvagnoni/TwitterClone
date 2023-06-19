//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/19/23.
//

import Foundation

class ProfileViewMpdel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    
    private let tweetService = TweetService()
    let user: User
    
    init(user: User) {
        
        self.user = user
        
        self.fetchUserTweets()
        
    }
    
    func fetchUserTweets() {
        
        guard let uid = user.id else { return }
        
        tweetService.fetchTweets(forUid: uid) { tweets in
            
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                
                self.tweets[i].user = self.user
                
            }
        }
        
    }
}
