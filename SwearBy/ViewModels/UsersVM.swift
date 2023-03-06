//
//  UserVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//Required Queries
    // Listen for one user
    // Check if one user exists (with email)
    // Add names for user


class UsersVM: ObservableObject, Identifiable {

    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var one_user = EmptyVariables().empty_user
    @Published var get_user_by_id = EmptyVariables().empty_user
    @Published var all_users = [Users]()
    @Published var get_users_by_phone_number = [Users]()
    
    var one_user_listener: ListenerRegistration!
    
    
    
    func listenForOneUser(user_id: String) {
        
        print("PASSING THE FOLLOWING USER_ID TO FIND IT \(user_id)")

        self.dm.getOneUserListener(user_id: user_id, onSuccess: { (user) in

            self.one_user = user

            print("FOUND ONE USER!!!")
            print(self.one_user)

        }, listener: { (listener) in
            self.one_user_listener = listener
        })
    }
    
//    func checkForUser(email: String) {
//
//        db.collection("users")
//            .whereField("profile.email", isEqualTo: email)
//            .limit(to: 1)
//            .getDocuments { (snap, err) in
//
//                guard let snapshot = snap, err == nil else {
//                    print("found error trying to get user")
//                    self.didFindUser = true
//                    return
//                }
//
//                if (snapshot.documents.count == 0) {
//                    //handle scenario where user isn't found
//                    print("did not find any documents for the email \(email)")
//                    self.didFindUser = false
//                    return
//                } else {
//                    print("Found at least 1 document, so there's a user")
//                    self.didFindUser = true
//                    return
//                }
//            }
//    }
    
    func updateName(user_id: String, first_name: String, last_name: String) {

        if user_id.isEmpty { return } else {

            db.collection("users").document(user_id)
                .updateData([
                    "name.first": first_name,
                    "name.first_last": first_name + " " + last_name,
                    "name.last": last_name
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
        }
    }
    
    func getUserByID(user_id: String) {
        
        let docRef = db.collection("users").document(user_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_user_by_id = try document.data(as: Users.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
        
    }
    
    func getAllUsers() {
        
        db.collection("users")
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.all_users = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
    
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
                })
            }
    }
    
    
    
    
    
    func getUserByPhoneNumber(number: String) {
        
        db.collection("users")
            .whereField("phone", isEqualTo: number)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.get_users_by_phone_number = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
                    print("AT THE TRY STATEMENT for getMyReferrals")
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
                })
            }
        
        
    }
    
    
    func sendFriendRequest(my_user_object: Users, my_friends_user_object: Users) {
         
        // Add me to their "friend requests" list
        var friends_current_requests:[String] = my_friends_user_object.friend_requests
        friends_current_requests.append(my_user_object.user_id)
        
        db.collection("users").document(my_friends_user_object.user_id)
            .updateData([
                "friend_requests": friends_current_requests
            ]) { err in
                if let err = err {
                    print("Error updating document submitting names for User object: \(err)")
                } else {
                    print("Updated the first and last names")
                }
            }
        
        // Add them to my "friends added" list
        var my_friends_added:[String] = my_user_object.friends_added
        my_friends_added.append(my_friends_user_object.user_id)
        
        db.collection("users").document(my_user_object.user_id)
            .updateData([
                "friends_added": my_friends_added
            ]) { err in
                if let err = err {
                    print("Error updating document submitting names for User object: \(err)")
                } else {
                    print("Updated the first and last names")
                }
            }
    }
    
    func acceptFriendRequest(my_user_object: Users, my_friends_user_object: Users) {
        
        // Add me to their list
        var friends_friends_list = my_friends_user_object.friends_list
        friends_friends_list.append(my_user_object.user_id)
        
        // Remove me from their "added friends" list
        var friends_friends_added = my_friends_user_object.friends_added
        if let index = friends_friends_added.firstIndex(where: {$0 == my_user_object.user_id}) {
            friends_friends_added.remove(at: index)
        }
        
        // Update their account
        db.collection("users").document(my_friends_user_object.user_id)
            .updateData([
                "friends_added": friends_friends_added,
                "friends_list": friends_friends_list
            ]) { err in
                if let err = err {
                    print("Error updating document submitting names for User object: \(err)")
                } else {
                    print("Updated the first and last names")
                }
            }
        
        // Add them to my list
        var my_friends_list = my_user_object.friends_list
        my_friends_list.append(my_friends_user_object.user_id)
        
        // Remove them from my "friend requests" list
        var my_friend_requests = my_user_object.friend_requests
        if let index = my_friend_requests.firstIndex(where: {$0 == my_friends_user_object.user_id}) {
            my_friend_requests.remove(at: index)
        }
        
        // Update my account
        db.collection("users").document(my_user_object.user_id)
            .updateData([
                "friend_requests": my_friend_requests,
                "friends_list": my_friends_list
            ]) { err in
                if let err = err {
                    print("Error updating document submitting names for User object: \(err)")
                } else {
                    print("Updated the first and last names")
                }
            }
        
        
        
    }
}
