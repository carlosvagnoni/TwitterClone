//
//  FeedViewModel.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    
    @Published var tweetsData = [TweetData]()
    @Published var isLoading = false
    
    let tweetService = TweetService()
    let userService = UserService()
    
    struct TweetData {
        let tweet: Tweet
        let relevantDate: Date
        let isRetweet: Bool
        let retweetedUserFullname: String?
    }
    
    init() {
        
        fetchTweets()
        
    }
    
    
//    func fetchTweets() {
//
//        isLoading = true
//
//        tweetService.fetchTweets { tweets in
//
//            DispatchQueue.main.async {
//
//                self.tweets = tweets
//
//                self.isLoading = false
//
//            }
//
//        }
//
//    }
    
    func fetchTweets() {
        isLoading = true

        let group = DispatchGroup()

        var tweetDataList = [TweetData]()

        group.enter()
        tweetService.fetchTweets { tweets in
            tweetDataList.append(contentsOf: tweets.map {
                TweetData(tweet: $0, relevantDate: $0.timestamp.dateValue(), isRetweet: false, retweetedUserFullname: nil)
            })
            group.leave()
        }

        group.enter()
        userService.fetchUsersWithRetweets { users in
            let retweetGroup = DispatchGroup()

            for user in users {
                guard let userId = user.id else { continue }
                
                retweetGroup.enter()
                self.tweetService.fetchRetweetedTweets(forUid: userId) { tweets in
                    for tweet in tweets {
                        guard let tweetId = tweet.id else { continue }
                        retweetGroup.enter()
                        self.tweetService.fetchRetweetDate(forUserId: userId, tweetId: tweetId) { retweetDate in
                            if let retweetDate = retweetDate {
                                tweetDataList.append(TweetData(tweet: tweet, relevantDate: retweetDate, isRetweet: true, retweetedUserFullname: user.fullname))
                            }
                            retweetGroup.leave()
                        }
                    }
                    retweetGroup.leave()
                }
            }

            retweetGroup.notify(queue: .main) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.tweetsData = tweetDataList.sorted(by: { $0.relevantDate > $1.relevantDate })
            self.isLoading = false
        }
    }


    
}
