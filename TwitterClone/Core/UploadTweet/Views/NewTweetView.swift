//
//  NewTweetView.swift
//  TwitterClone
//
//  Created by user239477 on 6/4/23.
//

import SwiftUI
import Kingfisher

struct NewTweetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    @ObservedObject var uploadTweetViewModel = UploadTweetViewModel()
    
    @State private var caption = ""
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button {
                    
                    dismiss()
                    
                } label: {
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                    
                }
                
                Spacer()
                
                Button {
                    
                    uploadTweetViewModel.uploadTweet(withCaption: caption)
                    
                } label: {
                    
                    Text("Tweet")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                    
                }
                
            }
            .padding(12)
            
            HStack(alignment: .top, spacing: 0) {
                
                if let user = authViewModel.currentUser {
                    
                    KFImage(URL(string: user.profilePhotoUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .padding(12)
                    
                }
                
                
                TextArea("What's happening?", text: $caption)
                
                
            }
            
        }
        .onReceive(uploadTweetViewModel.$didUploadTweet) { success in
            
            if success {
                
                feedViewModel.fetchTweets()
                
                dismiss()
                
            } else {
                
                // Handle error here...
                
            }
        }
        
    }
}

struct NewTweetView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NewTweetView()
            .environmentObject(AuthViewModel())
        
    }
}
