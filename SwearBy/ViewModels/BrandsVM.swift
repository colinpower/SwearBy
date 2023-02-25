//
//  BrandsVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class BrandsVM: ObservableObject, Identifiable {

    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var get_brand_by_id = Brands(name: "", website: "", brand_id: "")
        
    func getBrandById(brand_id: String) {
        
        let docRef = db.collection("brands").document(brand_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_brand_by_id = try document.data(as: Brands.self)
                        print(self.get_brand_by_id)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
        
    }
    
    
}
