//
//  TweetRowView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI

struct TweetRowView: View {
    
    let tweet: Tweet
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                //Profile image + User info + Tweet
                HStack(alignment: .top, spacing: 12) {
                    
                    //Profile Image
                    Circle()
                        .frame(width: 56, height: 56)
                        .foregroundColor(Color(.systemBlue))
                    
                    //User info + Tweet caption
                    VStack(alignment: .leading, spacing: 4) {
                        
                        //User info
                        HStack(spacing: 2.5) {
                            
                            Text("Lando Norris")
                                .font(.subheadline).bold()
                            
                            Text("@LightningMcQueen")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text("· 2m")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        
                        //Tweet caption
                        Text(tweet.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                }
                
                //Action buttons
                HStack {
                    
                    HStack {
                        
                    }
                    .frame(width: 56)
                    .padding(.trailing, 3)
                    
                    HStack {
                        
                        Button {
                            
                            //Action 1
                            
                        } label: {
                            
                            Image(systemName: "bubble.left")
                                .font(.subheadline)
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            //Action 2
                            
                        } label: {
                            
                            Image(systemName: "arrow.2.squarepath")
                                .font(.subheadline)
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            //Action 3
                            
                        } label: {
                            
                            Image(systemName: "heart")
                                .font(.subheadline)
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            //Action 4
                            
                        } label: {
                            
                            Image(systemName: "bookmark")
                                .font(.subheadline)
                            
                        }
                        
                    }
                    .padding(.top, 12)
                    .foregroundColor(.gray)
                }
                
                
                
            }
            .padding(12)
            
            Divider()

        }
        
    }
}

//struct TweetRowView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        
//        TweetRowView()
//        
//    }
//}
