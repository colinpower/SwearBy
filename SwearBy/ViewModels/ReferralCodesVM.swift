//
//  ReferralCodesVM.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class ReferralCodesVM: ObservableObject, Identifiable {
    
    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var my_referral_codes = [ReferralCodes]()
    
    func getMyReferralCodes(user_id: String) {
        
        db.collection("referral_codes")
            .whereField("user_id", isEqualTo: user_id)
            .getDocuments { (snapshot, error) in
                
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
                
                self.my_referral_codes = snapshot.documents.compactMap({ queryDocumentSnapshot -> ReferralCodes? in
                    
                    print(try? queryDocumentSnapshot.data(as: ReferralCodes.self) as Any)
                    return try? queryDocumentSnapshot.data(as: ReferralCodes.self)
                })
            }
    }
}
