//
//  TweetRowView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct TweetRowView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var tweetRowViewModel: TweetRowViewModel
    
    var isRetweet: Bool?
    var retweetedUserFullname: String?
    
    init(tweet: Tweet) {
        
        self.tweetRowViewModel = TweetRowViewModel(tweet: tweet)
        self.isRetweet = false
        self.retweetedUserFullname = nil
        
    }
    
    init(tweet: Tweet, isRetweet: Bool, retweetedUserFullname: String?) {
            self.tweetRowViewModel = TweetRowViewModel(tweet: tweet)
            self.isRetweet = isRetweet
            self.retweetedUserFullname = retweetedUserFullname
        }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                if let isRetweet = isRetweet {
                    
                    if isRetweet {
                        HStack(alignment: .top, spacing: 9) {
                            
                            Spacer()
                                .frame(width: 56)
                            
                            HStack(spacing: 5) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                
                                
                                Text(authViewModel.currentUser?.fullname == retweetedUserFullname ? "You Retweeted" : "\(retweetedUserFullname ?? "Unknown") Retweeted")
                                    .font(.subheadline).bold()
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                                
                                
                            }
                            
                            
                            
                        }
                        .padding(.bottom, 10)
                    }
                }
                
                //Profile image + User info + Tweet
                HStack(alignment: .top, spacing: 12) {
                    
                    if let user = tweetRowViewModel.tweet.user {
                        
                        //Profile Image
                            KFImage(URL(string: user.profilePhotoUrl))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 56, height: 56)
                                .foregroundColor(Color(.systemBlue))
                        
                        
                        //User info + Tweet caption
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

                                    Text(" · \(DateFormatterUtils.formatTimestamp(tweetRowViewModel.tweet.timestamp))")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .layoutPriority(3)
                                
                            }
                            
                            
                            
                            
                            //Tweet caption
                            Text(tweetRowViewModel.tweet.caption)
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
                                  
                        //User info + Tweet caption
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

                            //Tweet caption
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
                            
                            HStack(spacing: 2) {
                                Image(systemName: "bubble.left")
                                    .font(.subheadline)
                                Text("0")
                                    .font(.subheadline)
                                
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            tweetRowViewModel.tweet.didRetweet ?? false ? tweetRowViewModel.unretweetTweet() : tweetRowViewModel.retweetTweet()
                            
                        } label: {
                            
                            HStack(spacing: 2) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.subheadline)
                                Text(tweetRowViewModel.tweet.retweetCount == 0 ? "" : "\(tweetRowViewModel.tweet.retweetCount)")
                                    .font(.subheadline)
                            }
                            .foregroundColor(tweetRowViewModel.tweet.didRetweet ?? false ? .green : .gray)
                            
                                
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            tweetRowViewModel.tweet.didLike ?? false ? tweetRowViewModel.unlikeTweet() : tweetRowViewModel.likeTweet()
                            
                        } label: {
                            HStack(spacing: 2) {
                                Image(systemName: tweetRowViewModel.tweet.didLike ?? false ? "heart.fill" : "heart")
                                    .font(.subheadline)
                                Text(tweetRowViewModel.tweet.likes == 0 ? "" : "\(tweetRowViewModel.tweet.likes)")
                                    .font(.subheadline)
                            }
                            .foregroundColor(tweetRowViewModel.tweet.didLike ?? false ? .red : .gray)
                            
                                
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            tweetRowViewModel.tweet.didBookmark ?? false ? tweetRowViewModel.unbookmarkTweet() : tweetRowViewModel.bookmarkTweet()
                            
                        } label: {
                            HStack(spacing:2) {
                                Image(systemName: tweetRowViewModel.tweet.didBookmark ?? false ? "bookmark.fill" : "bookmark")
                                    .font(.subheadline)
                                Text(tweetRowViewModel.tweet.bookmarkCount == 0 ? "" : "\(tweetRowViewModel.tweet.bookmarkCount)")
                                    .font(.subheadline)
                            }
                            .foregroundColor(tweetRowViewModel.tweet.didBookmark ?? false ? .blue : .gray)
                                
                            
                        }
                        
                    }
                    .padding(.top, 12)
                    .foregroundColor(.gray)
                }
                
                
                
            }
            .padding(12)
            
            Divider()

        }
        .frame(minHeight: 110)
        
        
    }
}

struct TweetRowView_Previews: PreviewProvider {
    
    static let tweet = Tweet(caption: "Prueba", timestamp: Timestamp(date: Date()), uid: "VBEo4qsxtTaYBgc4BK4wkh0mvAh1", likes: 0, bookmarkCount: 0, retweetCount: 0)
    
    static var previews: some View {
        
        TweetRowView(tweet: tweet)
            .environmentObject(AuthViewModel())
        
    }
}
