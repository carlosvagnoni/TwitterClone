//
//  InteractionNotifier.swift
//  TwitterClone
//
//  Created by user239477 on 7/12/23.
//

import Combine

class InteractionNotifier: ObservableObject {
    static let shared = InteractionNotifier()
    private init() {}
    
    let likeInteractionStatus = PassthroughSubject<Void, Never>()
    let retweetInteractionStatus = PassthroughSubject<Void, Never>()
    let bookmarkInteractionStatus = PassthroughSubject<Void, Never>()
    let tweetDeleted = PassthroughSubject<Void, Never>()
}
