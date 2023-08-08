//
//  BookmarksView.swift
//  TwitterClone
//
//  Created by user239477 on 6/28/23.
//

import SwiftUI

struct BookmarksView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var bookmarksViewModel = BookmarksViewModel()
    
    var body: some View {
        
        VStack {
            
            if bookmarksViewModel.isLoading {
                
                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(bookmarksViewModel.bookmarkedTweets) { tweet in
                                
                                TweetRowView(tweet: tweet)
                                
                            }
                        }
                        
                    }
           
                }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Bookmarks")
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
        .toolbarBackground(.visible)
        .onAppear() {
            
            bookmarksViewModel.fetchBookmarkedTweets()
            
        }
        .onReceive(InteractionNotifier.shared.bookmarkInteractionStatus) { _ in
            bookmarksViewModel.fetchBookmarkedTweets()
        }
        .onReceive(InteractionNotifier.shared.tweetDeleted) { _ in
            bookmarksViewModel.fetchBookmarkedTweets()
        }

    }
}

struct BookmarksView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BookmarksView()
        
    }
}
