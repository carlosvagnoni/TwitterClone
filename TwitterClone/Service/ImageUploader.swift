//
//  ImageUploader.swift
//  TwitterClone
//
//  Created by user239477 on 6/11/23.
//

import FirebaseStorage
import UIKit

struct ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            
            if let error = error {
                
                print("DEBUG: Failed upload image with error \(error.localizedDescription)")
                
                return
                
            }
            
            ref.downloadURL { imageUrl, _ in
                
                guard let imageUrl = imageUrl?.absoluteString else { return }
                
                completion(imageUrl)
                
            }
            
        }
        
    }
    
}
