//
//  TweetService.swift
//  TwitterClone
//
//  Created by user239477 on 6/16/23.
//

import Firebase
import FirebaseStorage

class TweetService {
    
    func uploadTweet(caption: String, mediaUrl: String?, mediaType: MediaType?, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var data: [String: Any] = ["uid": uid,
                                   "caption": caption,
                                   "commentCount": 0,
                                   "likes": 0,
                                   "retweetCount": 0,
                                   "bookmarkCount": 0,
                                   "timestamp": Timestamp(date: Date())]
        
        if let mediaURL = mediaUrl, let mediaType = mediaType {
            data["mediaURL"] = mediaURL
            data["mediaType"] = mediaType.rawValue
        }
        
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                
                if let error = error {
                    print("Failed to upload tweet with error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func deleteTweet(tweetId: String, completion: @escaping(Bool) -> Void) {
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.getDocument { document, error in
            if let document = document, document.exists {
                if let mediaUrlString = document.get("mediaURL") as? String,
                   let mediaUrl = URL(string: mediaUrlString) {
                    
                    // Delete media in storage
                    let mediaRef = Storage.storage().reference(forURL: mediaUrlString)
                    mediaRef.delete { error in
                        if let error = error {
                            print("Failed to delete media with error \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                    }
                }
                
                // Delete tweet document and its associated data
                Firestore.firestore().collection("users").getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    
                    // iterate over all users
                    for document in documents {
                        let userId = document.documentID
                        
                        // delete likes, retweets and bookmarks of this tweet for each user
                        Firestore.firestore().collection("users").document(userId).collection("user-likes").document(tweetId).delete()
                        Firestore.firestore().collection("users").document(userId).collection("user-retweets").document(tweetId).delete()
                        Firestore.firestore().collection("users").document(userId).collection("user-bookmarks").document(tweetId).delete()
                    }
                    
                    // delete all comments of this tweet
                    let commentsRef = tweetRef.collection("comments")
                    commentsRef.getDocuments { snapshot, _ in
                        guard let documents = snapshot?.documents else { return }
                        for document in documents {
                            commentsRef.document(document.documentID).delete()
                        }
                        
                        // delete all notifications of this tweet
                        Firestore.firestore().collection("notifications").whereField("tweetId", isEqualTo: tweetId).getDocuments { (snapshot, error) in
                            guard let documents = snapshot?.documents else { return }
                            for document in documents {
                                Firestore.firestore().collection("notifications").document(document.documentID).delete()
                            }
                            
                            // after all comments and notifications are deleted, delete the tweet itself
                            tweetRef.delete() { error in
                                if let error = error {
                                    completion(false)
                                } else {
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist or failed to get the document.")
                completion(false)
            }
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self) })
                completion(tweets)
            }
    }
    
    func fetchTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void) {
        
        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self) })
                completion(tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }))
            }
    }
    
    func fetchTweet(withId id: String, completion: @escaping (Tweet) -> Void) {
        
        Firestore.firestore().collection("tweets").document(id)
            .getDocument { document, _ in
                
                guard let document = document, document.exists, let tweet = try? document.data(as: Tweet.self) else { return }
                completion(tweet)
            }
    }
    
    func fetchAndAssignTweetsToNotifications(notifications: [Notification], completion: @escaping ([Notification]) -> Void) {
        let tweetIds = notifications.map { $0.tweetId }
        
        fetchTweetsWithIds(tweetIds) { tweetsDict in
            var updatedNotifications = notifications
            for index in updatedNotifications.indices {
                let tweetId = updatedNotifications[index].tweetId
                if let tweet = tweetsDict[tweetId] {
                    updatedNotifications[index].tweet = tweet
                }
            }
            completion(updatedNotifications)
        }
    }

    func fetchTweetsWithIds(_ ids: [String], completion: @escaping ([String: Tweet]) -> Void) {
        let tweetsRef = Firestore.firestore().collection("tweets")
        let dispatchGroup = DispatchGroup()
        var tweetsDict = [String: Tweet]()
        
        for id in ids {
            dispatchGroup.enter()
            tweetsRef.document(id).getDocument { snapshot, _ in
                if let snapshot = snapshot, let tweet = try? snapshot.data(as: Tweet.self) {
                    tweetsDict[id] = tweet
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(tweetsDict)
        }
    }

}

// MARK: - likes

extension TweetService {
    
    func likeTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["likes": FieldValue.increment(Int64(1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedLikes = dataDescription?["likes"] as? Int ?? 0
                    userLikesRef.document(tweetId).setData(["likeDate": Timestamp(date: Date())]) { _ in
                        completion(updatedLikes)
                    }
                }
            }
        }
    }
    
    func unlikeTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        guard tweet.likes > 0 else { return }
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["likes": FieldValue.increment(Int64(-1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedLikes = dataDescription?["likes"] as? Int ?? 0
                    userLikesRef.document(tweetId).delete { _ in
                        completion(updatedLikes)
                    }
                }
            }
        }
    }
    
    
    func checkIfUserLikedTweet( _ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes").document(tweetId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            completion(snapshot.exists)
        }
    }
    
    func fetchLikedTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void) {
        var tweetsDict = [String: Tweet]()
        var likes = [DocumentSnapshot]()
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes")
            .order(by: "likeDate", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                
                if documents.isEmpty {
                    completion([])
                    return
                }
                
                likes = documents
                
                likes.forEach { doc in
                    let tweetId = doc.documentID
                    
                    Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                        guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                        tweetsDict[tweetId] = tweet
                        if tweetsDict.count == likes.count {
                            let sortedTweets = likes.compactMap({ tweetsDict[$0.documentID] })
                            completion(sortedTweets)
                        }
                    }
                }
            }
    }
    
}

// MARK: - retweets

extension TweetService {
    
    func retweetTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        let userRetweetsRef = Firestore.firestore().collection("users").document(uid).collection("user-retweets")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["retweetCount": FieldValue.increment(Int64(1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedRetweetCount = dataDescription?["retweetCount"] as? Int ?? 0
                    userRetweetsRef.document(tweetId).setData(["retweetDate": Timestamp(date: Date())]) { _ in
                        completion(updatedRetweetCount)
                    }
                }
            }
        }
    }
    
    func unretweetTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        guard tweet.retweetCount > 0 else { return }
        let userRetweetsRef  = Firestore.firestore().collection("users").document(uid).collection("user-retweets")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["retweetCount": FieldValue.increment(Int64(-1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedRetweetCount = dataDescription?["bookmarkCount"] as? Int ?? 0
                    userRetweetsRef.document(tweetId).delete { _ in
                        completion(updatedRetweetCount)
                    }
                }
            }
        }
    }
    
    
    func checkIfUserRetweetedTweet( _ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-retweets").document(tweetId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            completion(snapshot.exists)
        }
    }
    
    func fetchRetweetedTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void) {
        var tweetsDict = [String: Tweet]()
        var retweets = [DocumentSnapshot]()
        
        Firestore.firestore().collection("users").document(uid).collection("user-retweets")
            .order(by: "retweetDate", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                if documents.isEmpty {
                    completion([])
                    return
                }
                
                retweets = documents
                
                retweets.forEach { doc in
                    let tweetId = doc.documentID
                    
                    Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                        guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                        
                        tweetsDict[tweetId] = tweet
                        
                        if tweetsDict.count == retweets.count {
                            let sortedTweets = retweets.compactMap({ tweetsDict[$0.documentID] })
                            completion(sortedTweets)
                        }
                    }
                }
            }
    }
    
    func fetchRetweetDate(forUserId userId: String, tweetId: String, completion: @escaping (Date?) -> Void) {
        Firestore.firestore().collection("users").document(userId).collection("user-retweets").document(tweetId).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let data = document.data(),
               let retweetDate = (data["retweetDate"] as? Timestamp)?.dateValue() {
                completion(retweetDate)
            } else {
                completion(nil)
            }
        }
    }
}


// MARK: - bookmarks

extension TweetService {
    
    func bookmarkTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        let userBookmarksRef = Firestore.firestore().collection("users").document(uid).collection("user-bookmarks")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["bookmarkCount": FieldValue.increment(Int64(1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedBookmarkCount = dataDescription?["bookmarkCount"] as? Int ?? 0
                    userBookmarksRef.document(tweetId).setData(["bookmarkDate": Timestamp(date: Date())]) { _ in
                        completion(updatedBookmarkCount)
                    }
                }
            }
        }
    }
    
    func unbookmarkTweet(_ tweet: Tweet, completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        guard tweet.bookmarkCount > 0 else { return }
        let userBookmarksRef = Firestore.firestore().collection("users").document(uid).collection("user-bookmarks")
        let tweetRef = Firestore.firestore().collection("tweets").document(tweetId)
        
        tweetRef.updateData(["bookmarkCount": FieldValue.increment(Int64(-1))]) { _ in
            tweetRef.getDocument { (document, _) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let updatedBookmarkCount = dataDescription?["bookmarkCount"] as? Int ?? 0
                    userBookmarksRef.document(tweetId).delete { _ in
                        completion(updatedBookmarkCount)
                    }
                }
            }
        }
    }
    
    
    func checkIfUserBookmarkedTweet( _ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-bookmarks").document(tweetId).getDocument { snapshot, _ in
            
            guard let snapshot = snapshot else { return }
            completion(snapshot.exists)
        }
    }
    
    func fetchBookmarkedTweets(completion: @escaping([Tweet]) -> Void) {
        var tweetsDict = [String: Tweet]()
        var bookmarks = [DocumentSnapshot]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-bookmarks")
            .order(by: "bookmarkDate", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                if documents.isEmpty {
                    completion([])
                    return
                }
                
                bookmarks = documents
                
                bookmarks.forEach { doc in
                    let tweetId = doc.documentID
                    
                    Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                        guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                        
                        tweetsDict[tweetId] = tweet
                        
                        if tweetsDict.count == bookmarks.count {
                            let sortedTweets = bookmarks.compactMap({ tweetsDict[$0.documentID] })
                            completion(sortedTweets)
                        }
                    }
                }
            }
    }    
}

