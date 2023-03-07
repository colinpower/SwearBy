//
//  PreloadedReferralProgramVM.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class PreloadedReferralProgramVM: ObservableObject, Identifiable {
    
    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var preloaded_referral_programs = [PreloadedReferralPrograms]()
    
    func getPreloadedReferralPrograms() {
        
        db.collection("preloaded_referral_programs")
            .getDocuments { (snapshot, error) in
                
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
                
                self.preloaded_referral_programs = snapshot.documents.compactMap({ queryDocumentSnapshot -> PreloadedReferralPrograms? in
                    
                    print(try? queryDocumentSnapshot.data(as: PreloadedReferralPrograms.self) as Any)
                    return try? queryDocumentSnapshot.data(as: PreloadedReferralPrograms.self)
                })
            }
    }
}
