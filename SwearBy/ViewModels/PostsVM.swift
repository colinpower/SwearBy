//
//  PostsVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//Required Queries
    // Listen for one user
    // Check if one user exists (with email)
    // Add names for user


class PostsVM: ObservableObject, Identifiable {

    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var all_posts = [Posts]()
    
    @Published var my_posts = [Posts]()
    
    @Published var one_user_posts = [Posts]()
    
    @Published var posts_in_user_feed = [Posts]()
    
    var posts_in_user_feed_listener: ListenerRegistration!
    var my_posts_listener: ListenerRegistration!
    
    
    func getAllPosts() {
        
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.all_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> Posts? in
    
                    print(try? queryDocumentSnapshot.data(as: Posts.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Posts.self)
                })
            }
    }
    
    func listenForPostsInUserFeed(users_vm: UsersVM) {
    
        self.dm.getPostsInUserFeedListener(users_vm: users_vm, onSuccess: { (posts) in

            self.posts_in_user_feed = posts

            print("FOUND POSTS")
            print(self.posts_in_user_feed)

        }, listener: { (listener) in
            self.posts_in_user_feed_listener = listener
        })
    }
    
    func listenForMyPosts(users_vm: UsersVM) {
    
        self.dm.getMyPostsListener(users_vm: users_vm, onSuccess: { (posts) in

            self.my_posts = posts

        }, listener: { (listener) in
            self.my_posts_listener = listener
        })
    }
    
    

    func getOneUserPosts(user_id: String) {
        
        db.collection("posts")
            .whereField("user_id", isEqualTo: user_id)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.one_user_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> Posts? in
    
                    print(try? queryDocumentSnapshot.data(as: Posts.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Posts.self)
                })
            }
    }
    
    func addPost(description: String, is_public: Bool, is_verified: Bool, post_id: String, product_id: String, purchase_id: String, timestamp: Int, user_id: String) {
         
        db.collection("posts").document(post_id).setData([
            "description": description,
            "is_public": is_public,
            "is_verified": is_verified,
            "post_id": post_id,
            "product_id": product_id,
            "purchase_id": purchase_id,
            "timestamp": getTimestamp(),
            "user_id": user_id
        ]) { err in
            if let err = err {
                print("Error adding post: \(err)")
            } else {
                print("Other kind of error.. idk??")
            }
        }
    }
    
    
    
}
