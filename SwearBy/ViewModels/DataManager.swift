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
    
    
}
