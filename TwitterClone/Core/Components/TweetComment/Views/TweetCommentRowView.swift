//
//  TweetCommentRowView.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import SwiftUI
import Kingfisher

struct TweetCommentRowView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                
//                if let user = tweetCommentRowViewModel.comment.user {
//                    
//                    //Profile Image
//                        KFImage(URL(string: user.profilePhotoUrl))
//                            .resizable()
//                            .scaledToFill()
//                            .clipShape(Circle())
//                            .frame(width: 56, height: 56)
//                            .foregroundColor(Color(.systemBlue))
//                    
//                    
//                    //User info + Tweet caption
//                    VStack(alignment: .leading, spacing: 4) {
//                        
//                        //User info
//                        HStack(spacing: 2.5) {
//                            
//                            Text(user.fullname)
//                                    .font(.subheadline).bold()
//                                    .truncationMode(.tail)
//                                    .lineLimit(1)
//                                    .layoutPriority(2)
//
//                                Text(" @\(user.username)")
//                                    .foregroundColor(.gray)
//                                    .font(.subheadline)
//                                    .truncationMode(.tail)
//                                    .lineLimit(1)
//                                    .layoutPriority(1)
//
//                                Text(" · \(DateFormatterUtils.formatTimestamp(tweetRowViewModel.tweet.timestamp))")
//                                    .foregroundColor(.gray)
//                                    .font(.subheadline)
//                                    .lineLimit(1)
//                                    .layoutPriority(3)
//                            
//                        }
//                        
//                        
//                        
//                        
//                        //Tweet caption
//                        Text(tweetRowViewModel.tweet.caption)
//                            .font(.subheadline)
//                            .multilineTextAlignment(.leading)
                        
//                    }
                    
//                } else {
//
//                    //Profile Image
//                    Circle()
//                        .scaledToFill()
//                        .frame(width: 56, height: 56)
//                        .foregroundColor(Color.gray.opacity(0.5))
//                        .modifier(Shimmer())
//
//                    //User info + Tweet caption
//                    VStack(alignment: .leading, spacing: 4) {
//
//                        //User info
//
//                        HStack(spacing: 2.5) {
//
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.5))
//                                .frame(height: 8)
//                                .cornerRadius(5)
//                                .font(.subheadline).bold()
//                                .modifier(Shimmer())
//
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.5))
//                                .frame(height: 8)
//                                .cornerRadius(5)
//                                .font(.subheadline)
//                                .modifier(Shimmer())
//
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.5))
//                                .frame(height: 8)
//                                .cornerRadius(5)
//                                .font(.subheadline)
//                                .modifier(Shimmer())
//                        }
//
//                        //Tweet caption
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.5))
//                            .frame(height: 8)
//                            .cornerRadius(5)
//                            .font(.subheadline)
//                            .multilineTextAlignment(.leading)
//                            .padding(.top, 5)
//                            .modifier(Shimmer())
//
//                    }
//                    
//                }
                
            }
        }
    }
}

struct TweetCommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        TweetCommentRowView()
    }
}
