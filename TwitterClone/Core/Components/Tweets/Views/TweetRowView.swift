//
//  TweetRowView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI
import Kingfisher
import Firebase
import AVKit

struct TweetRowView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var tweetRowViewModel: TweetRowViewModel
    
    @State var shouldNavigateToTweetView = false
    @State var isConfirmationViewPresented = false
    
    var isRetweet: Bool?
    var retweetedUserFullname: String?
    var isAlreadyInTweetView: Bool
    
    init(tweet: Tweet, isAlreadyInTweetView: Bool = false) {
        self.tweetRowViewModel = TweetRowViewModel(tweet: tweet)
        self.isRetweet = false
        self.retweetedUserFullname = nil
        self.isAlreadyInTweetView = isAlreadyInTweetView
    }
    
    init(tweet: Tweet, isRetweet: Bool, retweetedUserFullname: String?, isAlreadyInTweetView: Bool = false) {
        self.tweetRowViewModel = TweetRowViewModel(tweet: tweet)
        self.isRetweet = isRetweet
        self.retweetedUserFullname = retweetedUserFullname
        self.isAlreadyInTweetView = isAlreadyInTweetView
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: TweetView(tweet: tweetRowViewModel.tweet), isActive: $shouldNavigateToTweetView, label: {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !isAlreadyInTweetView {
                            shouldNavigateToTweetView = true
                        }
                    }
            })
            
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
                    
                    HStack(alignment: .top, spacing: 12) {
                        if let user = tweetRowViewModel.tweet.user {
                            NavigationLink {
                                ProfileView(user: user)
                            } label: {
                                KFImage(URL(string: user.profilePhotoUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 56, height: 56)
                                    .foregroundColor(Color(.systemBlue))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
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
                                    
                                    Spacer()
                                    
                                    if user.isCurrentUser {
                                        Button {
                                            isConfirmationViewPresented = true
                                        } label: {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.clear)
                                                
                                                Image(systemName: "ellipsis")
                                                    .font(.subheadline)
                                                    .rotationEffect(.degrees(90))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(width: 5, height: 18)
   
                                    }
                                }
                                Text(tweetRowViewModel.tweet.caption)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                if let tweetMediaType = tweetRowViewModel.tweet.mediaType {
                                    
                                    switch tweetMediaType {
                                    case .image:
                                        KFImage(URL(string: tweetRowViewModel.tweet.mediaURL!))
                                            .resizable()
                                            .placeholder{
                                                ProgressView()
                                                    .tint(Color(.systemBlue))
                                                    .scaleEffect(2)
                                            }
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .padding(.top, 8)
                                    case .video:
                                        VStack {
                                            VideoPlayer(player: AVPlayer(url: URL(string: tweetRowViewModel.tweet.mediaURL!)!))
                                                .aspectRatio(contentMode: .fill)
                                                .padding(.top, 8)
                                        }
                                        .frame(maxHeight: 400)
   
                                    }
                                }
                            }
                        } else {
                            
                            Circle()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .foregroundColor(Color.gray.opacity(0.5))
                                .modifier(Shimmer())
                            
                            VStack(alignment: .leading, spacing: 4) {
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
                    
                    HStack {
                        HStack {
                        }
                        .frame(width: 56)
                        .padding(.trailing, 3)
                        
                        HStack {
                            Button {
                                shouldNavigateToTweetView = true
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "bubble.left")
                                        .font(.subheadline)
                                    Text(tweetRowViewModel.tweet.commentCount == 0 ? "" : "\(CounterFormatterUtils.formatCounter(tweetRowViewModel.tweet.commentCount))")
                                        .font(.subheadline)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                tweetRowViewModel.tweet.didRetweet ?? false ? tweetRowViewModel.unretweetTweet {
                                    Task {
                                        if !isAlreadyInTweetView {
                                            InteractionNotifier.shared.retweetInteractionStatus.send()
                                        }
                                    }
                                } : tweetRowViewModel.retweetTweet {
                                    Task {
                                        if !isAlreadyInTweetView {
                                            InteractionNotifier.shared.retweetInteractionStatus.send()
                                        }
                                    }
                                }
                                
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "arrow.2.squarepath")
                                        .font(.subheadline)
                                    Text(tweetRowViewModel.tweet.retweetCount == 0 ? "" : "\(CounterFormatterUtils.formatCounter(tweetRowViewModel.tweet.retweetCount))")
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
                                    Text(tweetRowViewModel.tweet.likes == 0 ? "" : "\(CounterFormatterUtils.formatCounter(tweetRowViewModel.tweet.likes))")
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
                                    Text(tweetRowViewModel.tweet.bookmarkCount == 0 ? "" : "\(CounterFormatterUtils.formatCounter(tweetRowViewModel.tweet.bookmarkCount))")
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
                    .background(Color("dividerColor"))
                
            }
            .frame(minHeight: 110)
            .sheet(isPresented: $isConfirmationViewPresented) {
                DeleteTweetConfirmationView(tweet: tweetRowViewModel.tweet)
                    .presentationDetents([.fraction(0.25)])
            }
        }
    }
}

struct TweetRowView_Previews: PreviewProvider {
    static let tweet = Tweet(caption: "Prueba", timestamp: Timestamp(date: Date()), uid: "VBEo4qsxtTaYBgc4BK4wkh0mvAh1", commentCount: 0, likes: 0, bookmarkCount: 0, retweetCount: 0)
    
    static var previews: some View {
                
        TweetRowView(tweet: tweet)
            .environmentObject(AuthViewModel())
    }
}
