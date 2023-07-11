//
//  DeleteTweetConfirmationView.swift
//  TwitterClone
//
//  Created by user239477 on 7/9/23.
//

import SwiftUI

struct DeleteTweetConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var deleteTweetConfirmationViewModel: DeleteTweetConfirmationViewModel
    
    init(tweet: Tweet) {
        self.deleteTweetConfirmationViewModel = DeleteTweetConfirmationViewModel(tweet: tweet)
    }
    
    var body: some View {
        
        VStack {
            Text("Do you want to delete this tweet?")
                .font(.title2)
                .padding(12)
            
            HStack {
                Button {
                    deleteTweetConfirmationViewModel.deleteTweet()
                } label: {
                    Text("Yes")
                        .frame(minWidth: 120)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                }
                
                
                Button {
                    dismiss()
                } label: {
                    Text("No")
                        .frame(minWidth: 120)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(Color(.systemBlue))
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color(.systemBlue), lineWidth: 2)
                        )
                }
            }
        }
        .onReceive(deleteTweetConfirmationViewModel.$didDeletedTweet) { success in
            
            if success {
                
                dismiss()
                TweetDeleteNotifier.shared.tweetDeleted.send(())
                
            } else {
                
                // Handle error here...
                
            }
        }
        
        
    }
}

//struct DeleteTweetConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteTweetConfirmationView()
//    }
//}
