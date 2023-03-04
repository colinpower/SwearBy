//
//  RequestEmailLinkVM.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class RequestEmailLinkVM: ObservableObject, Identifiable {
    
    private var db = Firestore.firestore()
    
    func requestEmailLink(email: String) {
        
        db.collection("auth_email_link").document()
            .setData([
                "email": email,
            ]) { err in
                if let err = err {
                    print("Error adding document for requestEmailLink: \(err)")
                } else {
                    print("ERROR with requesting email link? \(err)")
                }
            }
    }
    
}
