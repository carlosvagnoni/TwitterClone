//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/16/23.
//

import Foundation
import SwiftUI

//class UploadTweetViewModel: ObservableObject {
//
//    @Published var didUploadTweet = false
//
//    let tweetService = TweetService()
//
//    func uploadTweet(withCaption caption: String) {
//
//        tweetService.uploadTweet(caption: caption) { success in
//
//            if success {
//
//                self.didUploadTweet = true
//
//            } else {
//
//                // Show error message...
//
//            }
//        }
//
//    }
//}

class UploadTweetViewModel: ObservableObject {

    @Published var didUploadTweet = false

    let tweetService = TweetService()

    func uploadTweet(caption: String, image: UIImage? = nil, videoData: Data? = nil, completion: @escaping (Bool) -> Void) {
        
        if let image = image {
            MediaUploader.uploadImage(image: image) { mediaUrl in
                self.tweetService.uploadTweet(caption: caption, mediaUrl: mediaUrl, mediaType: .image) { success in
                    if success {
                        self.didUploadTweet = true
                        completion(true)
                    } else {
                        // Show error message...
                        completion(false)
                    }
                }
            }
        } else if let videoData = videoData {
            MediaUploader.uploadVideo(videoData: videoData) { mediaUrl in
                self.tweetService.uploadTweet(caption: caption, mediaUrl: mediaUrl, mediaType: .video) { success in
                    if success {
                        self.didUploadTweet = true
                        completion(true)
                    } else {
                        // Show error message...
                        completion(false)
                    }
                }
            }
        } else {
            tweetService.uploadTweet(caption: caption, mediaUrl: nil, mediaType: nil) { success in
                if success {
                    self.didUploadTweet = true
                    completion(true)
                } else {
                    // Show error message...
                    completion(false)
                }
            }
        }
        
    }
}


