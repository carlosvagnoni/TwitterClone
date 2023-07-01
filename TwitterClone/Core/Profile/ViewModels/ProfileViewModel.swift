//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/19/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    @Published var likedTweets = [Tweet]()
    @Published var retweetedTweets = [Tweet]()
    
    private let tweetService = TweetService()
    private let userService = UserService()
    
    let user: User
    
    init(user: User) {
        
        self.user = user
        
        self.fetchUserTweets()
        
        self.fetchLikedTweets()
        
    }
    
    var actionButtonTitle: String {
        
        return user.isCurrentUser ? "Edit Profile" : "Follow"
        
    }
    
    func tweets(forFilter filter: TweetFilterViewModel) -> [Tweet] {
        
        switch filter {
            
        case .tweets:
            return tweets
            
        case .replies:
            return retweetedTweets
            
        case .likes:
            return likedTweets
            
        }
        
    }
    
    func fetchUserTweets() {
        
        guard let uid = user.id else { return }
        
        tweetService.fetchTweets(forUid: uid) { tweets in
            
            self.tweets = tweets
            
        }
        
    }
    
    func fetchLikedTweets() {
        
        guard let uid = user.id else { return }
        
        tweetService.fetchLikedTweets(forUid: uid) { tweets in
            
            self.likedTweets = tweets
            
        }
        
    }
    
    func fetchRetweetedTweets() {
        
        guard let uid = user.id else { return }
        
        tweetService.fetchRetweetedTweets(forUid: uid) { tweets in
            
            self.retweetedTweets = tweets
            
        }
        
    }
}
