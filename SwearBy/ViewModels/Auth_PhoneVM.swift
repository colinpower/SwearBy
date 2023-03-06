//
//  Auth_PhoneVM.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class Auth_PhoneVM: ObservableObject, Identifiable {
    
    var dm = DataManager()
    private var db = Firestore.firestore()
    
    func requestOTP(user: Users, phone: String, auth_phone_uuid: String) {
        
        db.collection("auth_phone").document(auth_phone_uuid)
            .setData([
                "correct_code": "",
                "phone": phone,
                "submitted_code": "",
                "timestamp": [
                    "created": getTimestamp(),
                    "expires": 0,
                    "submitted": 0,
                ],
                "uuid": [
                    "auth_phone": auth_phone_uuid,
                    "user": user.user_id
                ]
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("IDK ERROR WHEN SUBMITTING??")
                }
            }
    }
    
    func submitOTP(code: String, auth_phone_uuid: String) {
            
        db.collection("auth_phone").document(auth_phone_uuid)
            .updateData([
                "timestamp.submitted": getTimestamp(),
                "submitted_code": code
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("sending a verification code back to firebase")
                }
            }
    }
}
