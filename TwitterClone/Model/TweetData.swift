//
//  TweetData.swift
//  TwitterClone
//
//  Created by user244558 on 8/10/23.
//

import Foundation

struct TweetData {
    var tweet: Tweet
    let relevantDate: Date
    let isRetweet: Bool
    let retweetedUserFullname: String?
}
