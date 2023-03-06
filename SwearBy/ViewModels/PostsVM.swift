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
    @Published var one_user_posts = [Posts]()
    
    func getAllPosts() {
        
        db.collection("posts")
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
