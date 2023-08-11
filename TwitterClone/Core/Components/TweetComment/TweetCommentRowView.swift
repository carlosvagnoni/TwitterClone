//
//  TweetCommentRowView.swift
//  TwitterClone
//
//  Created by user239477 on 7/4/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct TweetCommentRowView: View {
    
    var comment: Comment
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    
                    if let user = comment.user {
                        
                        //Profile Image
                        KFImage(URL(string: user.profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 56, height: 56)
                            .foregroundColor(Color(.systemBlue))
                        
                        
                        //User info + Comment
                        VStack(alignment: .leading, spacing: 4) {
                            
                            //User info
                            HStack(spacing: 2.5) {
                                Text(user.fullname)
                                    .font(.subheadline).bold()
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .layoutPriority(2)
                                
                                Text(" @\(user.username)")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                
                                Text(" · \(DateFormatterUtils.formatTimestamp(comment.timestamp))")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .layoutPriority(3)
                                
                                Spacer()
                            }
                            
                            //Comment
                            Text(comment.comment)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        
                    } else {
                        //Profile Image
                        Circle()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .foregroundColor(Color.gray.opacity(0.5))
                            .modifier(Shimmer())
                        
                        //User info + Comment
                        VStack(alignment: .leading, spacing: 4) {
                            
                            //User info
                            HStack(spacing: 2.5) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 8)
                                    .cornerRadius(5)
                                    .font(.subheadline).bold()
                                    .modifier(Shimmer())
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 8)
                                    .cornerRadius(5)
                                    .font(.subheadline)
                                    .modifier(Shimmer())
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 8)
                                    .cornerRadius(5)
                                    .font(.subheadline)
                                    .modifier(Shimmer())
                            }
                            
                            //Comment
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 8)
                                .cornerRadius(5)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                                .modifier(Shimmer())
                        }
                    }
                }
            }
            .padding(12)
            
            Divider()
                .background(Color("dividerColor"))
        }
        .frame(minHeight: 80)
    }
}

struct TweetCommentRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        TweetCommentRowView(comment: Comment.MOCK_COMMENT)
    }
}
