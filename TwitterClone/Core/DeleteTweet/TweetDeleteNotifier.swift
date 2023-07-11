//
//  TweetDeleteNotifier.swift
//  TwitterClone
//
//  Created by user239477 on 7/11/23.
//

import Combine

class TweetDeleteNotifier: ObservableObject {
    static let shared = TweetDeleteNotifier()
    private init() {}
    
    let tweetDeleted = PassthroughSubject<Void, Never>()
}
