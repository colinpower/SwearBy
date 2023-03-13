//
//  DataManager.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager: ObservableObject {
    
    private var db = Firestore.firestore()
//    
//    func getCurrentUserByUID(userID: String, onSuccess: @escaping(Users) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
//        
//        let listenerRegistration = db.collection("users").document(userID)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                
//                var oneUserVariable = Users(profile: Struct_Profile(email: "", email_verified: false, name: Struct_Profile_Name(first: "", last: ""), phone: "", phone_verified: false), settings: Users_Settings(has_notifications: false), timestamp: Users_Timestamp(created: 0, deleted: 0), uuid: Users_UUID(user: ""))
//                
//                do {
//                    print("GOT HERE IN THE GETCURRENTUSERBYUID")
//                    oneUserVariable = try! document.data(as: Users.self)
//                    //return oneUserVariable //try? document.data(as: Users.self)
//                }
//                catch {
//                    print(error)
//                    return
//                }
//                //}
//                onSuccess(oneUserVariable)
//            }
//        listener(listenerRegistration) //escaping listener
//    }
//    
    func getOneUserListener(user_id: String, onSuccess: @escaping(Users) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("users").document(user_id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                var empty_user = EmptyVariables().empty_user
                
                do {
                    print("GOT HERE IN THE getOneUserListener")
                    
                    if document.exists {
                        
                        print(document.data())
                        
                        empty_user = try! document.data(as: Users.self)
                    } else {
                        empty_user.user_id = "NO USER FOUND"
                    }
                }
                catch {
                    print(error)
                    return
                }
                onSuccess(empty_user)
            }
        listener(listenerRegistration) //escaping listener
    }
    
    
    func getPostsInUserFeedListener(users_vm: UsersVM, onSuccess: @escaping([Posts]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        var listOf10Friends = [""]
        if !Array(users_vm.one_user.friends_list.prefix(10)).isEmpty {
            listOf10Friends = Array(users_vm.one_user.friends_list.prefix(10))
        }

        // let listOf10Friends = Array(users_vm.one_user.friends_list.prefix(10))
        
        let listenerRegistration = db.collection("posts")
            .whereField("user_id", in: listOf10Friends)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var postsArray = [Posts]()
                
                postsArray = documents.compactMap { (queryDocumentSnapshot) -> Posts? in
                    
                    
                    print(try? queryDocumentSnapshot.data(as: Posts.self))
                    return try? queryDocumentSnapshot.data(as: Posts.self)
                }
                onSuccess(postsArray)
            }
        listener(listenerRegistration)
    }
    
    
    func getMyPostsListener(users_vm: UsersVM, onSuccess: @escaping([Posts]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("posts")
            .whereField("user_id", isEqualTo: users_vm.one_user.user_id)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var mypostsArray = [Posts]()
                
                mypostsArray = documents.compactMap { (queryDocumentSnapshot) -> Posts? in
                    
                    print(try? queryDocumentSnapshot.data(as: Posts.self))
                    return try? queryDocumentSnapshot.data(as: Posts.self)
                }
                onSuccess(mypostsArray)
            }
        listener(listenerRegistration)
    }
    
    
    func getAllBrandsListener(onSuccess: @escaping([Brands]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("brands")
            .order(by: "name", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var brandsArray = [Brands]()
                
                brandsArray = documents.compactMap { (queryDocumentSnapshot) -> Brands? in
                    
                    
                    print(try? queryDocumentSnapshot.data(as: Brands.self))
                    return try? queryDocumentSnapshot.data(as: Brands.self)
                }
                onSuccess(brandsArray)
            }
        listener(listenerRegistration)
    }
    
    
    func getAllProductsForBrandListener(brand_id: String, onSuccess: @escaping([Products]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("products")
            .whereField("brand_id", isEqualTo: brand_id)
            .order(by: "name", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var productsForBrandArray = [Products]()
                
                productsForBrandArray = documents.compactMap { (queryDocumentSnapshot) -> Products? in
                    
                    
                    print(try? queryDocumentSnapshot.data(as: Products.self))
                    return try? queryDocumentSnapshot.data(as: Products.self)
                }
                onSuccess(productsForBrandArray)
            }
        listener(listenerRegistration)
    }
    
    
    func getMyReferralCodesListener(user_id: String, onSuccess: @escaping([ReferralCodes]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {

        let listenerRegistration = db.collection("referral_codes")
            .whereField("user_id", isEqualTo: user_id)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var temp_referral_codes_array = [ReferralCodes]()

                temp_referral_codes_array = documents.compactMap { (queryDocumentSnapshot) -> ReferralCodes? in


                    print(try? queryDocumentSnapshot.data(as: ReferralCodes.self))
                    return try? queryDocumentSnapshot.data(as: ReferralCodes.self)
                }
                onSuccess(temp_referral_codes_array)
            }
        listener(listenerRegistration)
    }
    
    
    
    
}
