//
//  PurchasesVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class PurchasesVM: ObservableObject, Identifiable {

    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var get_purchase_by_id = Purchases(brand_id: "", product_id: "", purchase_id: "", user_id: "", verification_status: "")
        
    func getPurchaseById(purchase_id: String) {
        
        let docRef = db.collection("purchases").document(purchase_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_purchase_by_id = try document.data(as: Purchases.self)
                        print(self.get_purchase_by_id)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
        
    }
    
    
}
