//
//  UserService.swift
//  TwitterClone
//
//  Created by user239477 on 6/13/23.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                
                guard let snapshot = snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else { return }
                completion(user)
            }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                documents.forEach { document in
                    
                    guard let user = try? document.data(as: User.self) else { return }
                    let users = documents.compactMap({ try? $0.data(as: User.self) })
                    completion(users)
                }
            }
    }
    
    func fetchUsers(withUids uids: [String], completion: @escaping ([String: User]) -> Void) {
        let usersRef = Firestore.firestore().collection("users")
        let dispatchGroup = DispatchGroup()
        var usersDict = [String: User]()
        
        for uid in uids {
            dispatchGroup.enter()
            usersRef.document(uid).getDocument { snapshot, _ in
                if let snapshot = snapshot, let user = try? snapshot.data(as: User.self) {
                    usersDict[uid] = user
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(usersDict)
        }
    }
    
    func fetchUsersWithRetweets(completion: @escaping([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            var usersWithRetweets: [User] = []
            let group = DispatchGroup()
            
            for document in documents {
                group.enter()
                
                guard let user = try? document.data(as: User.self), let userId = user.id else {
                    group.leave()
                    continue
                }
                
                Firestore.firestore().collection("users")
                    .document(userId)
                    .collection("user-retweets")
                    .getDocuments { (retweetsSnapshot, _) in
                        
                        if let retweetsDocuments = retweetsSnapshot?.documents, !retweetsDocuments.isEmpty {
                            usersWithRetweets.append(user)
                        }
                        
                        group.leave()
                    }
            }
            
            group.notify(queue: .main) {
                completion(usersWithRetweets)
            }
        }
    }
    
    func fetchAndAssignUsersToTweets(tweets: [Tweet], completion: @escaping ([Tweet]) -> Void) {
        let uids = tweets.map { $0.uid }

        self.fetchUsers(withUids: uids) { usersDict in
            var updatedTweets = tweets
            for index in updatedTweets.indices {
                let uid = updatedTweets[index].uid
                if let user = usersDict[uid] {
                    updatedTweets[index].user = user
                }
            }
            completion(updatedTweets)
        }
    }
    
    func fetchAndAssignUsersToTweetsData(tweetsData: [TweetData], completion: @escaping ([TweetData]) -> Void) {
        let uids = tweetsData.map { $0.tweet.uid }
        
        self.fetchUsers(withUids: uids) { usersDict in
            var updatedTweetsData = tweetsData
            for index in updatedTweetsData.indices {
                let uid = updatedTweetsData[index].tweet.uid
                if let user = usersDict[uid] {
                    updatedTweetsData[index].tweet.user = user
                }
            }
            completion(updatedTweetsData)
        }
    }
    
    func fetchAndAssignUsersToRecentMessages(recentMessages: [RecentMessage], completion: @escaping ([RecentMessage]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let otherUserIds = recentMessages.compactMap { $0.id }
        
        self.fetchUsers(withUids: otherUserIds) { usersDict in
            var updatedRecentMessages = recentMessages
            for index in updatedRecentMessages.indices {
                if let otherUserId = updatedRecentMessages[index].id,
                   let user = usersDict[otherUserId] {
                    updatedRecentMessages[index].receiverUser = user
                }
            }
            completion(updatedRecentMessages)
        }
    } 
}
