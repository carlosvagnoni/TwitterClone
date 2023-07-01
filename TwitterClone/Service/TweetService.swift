//
//  TweetService.swift
//  TwitterClone
//
//  Created by user239477 on 6/16/23.
//

import Firebase

class TweetService {
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid, "caption": caption, "likes": 0, "retweetCount": 0, "bookmarkCount": 0, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                
                if let error = error {
                    
                    completion(false)
                    return
                    
                }
                
                completion(true)
                
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
                    userLikesRef.document(tweetId).setData([:]) { _ in
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
        
        var tweets = [Tweet]()
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes").getDocuments { snapshot, _ in
            
            guard let document = snapshot?.documents else { return }
            
            if document.isEmpty {
                
                completion(tweets)
                
                return
            }
            
            document.forEach { doc in
                
                let tweetId = doc.documentID
                
                Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                    
                    guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                    
                    tweets.append(tweet)
                    
                    completion(tweets)
                }
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
                    userBookmarksRef.document(tweetId).setData([:]) { _ in
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
        
        var tweets = [Tweet]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-bookmarks").getDocuments { snapshot, _ in
            
            guard let document = snapshot?.documents else { return }
            
            if document.isEmpty {
                
                completion(tweets)
                
                return
            }
            
            document.forEach { doc in
                
                let tweetId = doc.documentID
                
                Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                    
                    guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                    
                    tweets.append(tweet)
                    
                    completion(tweets)
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
        
        var tweets = [Tweet]()
        
        Firestore.firestore().collection("users").document(uid).collection("user-retweets").getDocuments { snapshot, _ in
            
            guard let document = snapshot?.documents else { return }
            
            if document.isEmpty {
                
                completion(tweets)
                
                return
            }
            
            document.forEach { doc in
                
                let tweetId = doc.documentID
                
                Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                    
                    guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                    
                    tweets.append(tweet)
                    
                    completion(tweets)
                }
            }
        }
    }
    
}
