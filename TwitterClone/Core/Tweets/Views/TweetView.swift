//
//  TweetView.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import SwiftUI
import Firebase
import Kingfisher

struct TweetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @ObservedObject var tweetViewModel: TweetViewModel
    
    @State private var commentCaption = ""
    
    init(tweet: Tweet) {
        self.tweetViewModel = TweetViewModel(tweet: tweet)
    }

    var body: some View {

        ScrollView {
            
            //Tweet
            TweetRowView(tweet: tweetViewModel.tweet, isAlreadyInTweetView: true)
            
            //New Comment
            ZStack(alignment: .bottomTrailing) {
                HStack(alignment: .top, spacing: 0) {
                    
                    if let user = authViewModel.currentUser {
                        
                        KFImage(URL(string: user.profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .padding(12)
                        
                    }
                    
                    
                    TextArea("Leave your comment here.", text: $commentCaption)
                        .padding()
                        .padding(.bottom, 35)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 1)
                                .padding(.trailing, 12)
                        )
                    
                    
                }
                .padding(.top, 12)
                .padding(.bottom, 12)
                
                Button {
                    
                    tweetViewModel.uploadComment(comment: commentCaption)
                    
                } label: {
                    
                    Text("Comment")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                    
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
            

            //Comments
            if tweetViewModel.isLoading {

                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 20)

            } else {
                
                LazyVStack {
                    ForEach(tweetViewModel.comments) { comment in
                        TweetCommentRowView(comment: comment)
                    }
                }
                   
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Tweet")
        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "arrow.left.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)

                }
                .padding(0)

            }
    }
        .onAppear() {

            tweetViewModel.fetchComments()

        }
        .onReceive(tweetViewModel.$didUploadComment) { success in
            
            if success {
                
                tweetViewModel.fetchComments()
                commentCaption = ""
                
            } else {
                
                // Handle error here...
                
            }
        }

    }
}

struct TweetView_Previews: PreviewProvider {
    
    static let tweet = Tweet(id: "24kgxouwQPskp0ABhdtC",caption: "Prueba de TweetView", timestamp: Timestamp(date: Date()), uid: "VBEo4qsxtTaYBgc4BK4wkh0mvAh1", commentCount: 0, likes: 2, bookmarkCount: 3, retweetCount: 5)
    
    static var previews: some View {
        NavigationView {
            TweetView(tweet: tweet)
        }
        .environmentObject(AuthViewModel())
    }
}
