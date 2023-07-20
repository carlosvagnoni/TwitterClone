//
//  MediaUploader.swift
//  TwitterClone
//
//  Created by user239477 on 7/13/23.
//

import FirebaseStorage
import UIKit

struct MediaUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/tweet_media/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            
            if let error = error {
                
                print("DEBUG: Failed upload image with error \(error.localizedDescription)")
                
                return
                
            }
            
            ref.downloadURL { mediaUrl, _ in
                
                guard let mediaUrl = mediaUrl?.absoluteString else { return }
                
                completion(mediaUrl)
                
            }
            
        }
        
    }
    
    static func uploadVideo(videoData: Data, completion: @escaping(String) -> Void) {
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/tweet_media/\(filename)")
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        ref.putData(videoData, metadata: metadata) { _, error in
            
            if let error = error {
                
                print("DEBUG: Failed upload video with error \(error.localizedDescription)")
                
                return
                
            }
            
            ref.downloadURL { mediaUrl, _ in
                
                guard let mediaUrl = mediaUrl?.absoluteString else { return }
                
                completion(mediaUrl)
                
            }
            
        }
        
    }
    
}


