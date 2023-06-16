//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/16/23.
//

import Foundation

class UploadTweetViewModel: ObservableObject {
    
    @Published var didUploadTweet = false
    
    let tweetService = TweetService()
    
    func uploadTweet(withCaption caption: String) {
        
        tweetService.uploadTweet(caption: caption) { success in
            
            if success {
                
                self.didUploadTweet = true
                
            } else {
                
                // Show error message...
                
            }
        }
        
    }
}
