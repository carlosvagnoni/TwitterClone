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
                    
                    Spacer()
                    
                    
                    
                    HStack {
                        
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(2)
                        
                        Spacer()
                        
                    }
                    
                    
                    
                    Spacer()
                    
                }
    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(bookmarksViewModel.tweets) { tweet in
                                
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

    }
}
