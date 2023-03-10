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
    @Published var my_friends_referral_codes = [ReferralCodes]()
    
    var my_referral_codes_listener: ListenerRegistration!
    
    func listenForMyReferralCodes(user_id: String) {
    
        self.dm.getMyReferralCodesListener(user_id: user_id, onSuccess: { (my_codes) in
        
            self.my_referral_codes = my_codes

        }, listener: { (listener) in
            self.my_referral_codes_listener = listener
        })
    }

    
    
    func getMyFriendsCodes(users_vm: UsersVM) {
        
        let listOf10Friends = Array(users_vm.one_user.friends_list.prefix(10))
        
        db.collection("referral_codes")
            .whereField("user_id", in: listOf10Friends)
            .getDocuments { (snapshot, error) in
                
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
                
                self.my_friends_referral_codes = snapshot.documents.compactMap({ queryDocumentSnapshot -> ReferralCodes? in
                    
                    print(try? queryDocumentSnapshot.data(as: ReferralCodes.self) as Any)
                    return try? queryDocumentSnapshot.data(as: ReferralCodes.self)
                })
            }
    }
    
    
    
    
    func createNewReferralCode(
        brand_id: String,
        brand_name: String,
        code: String,
        commission_type: String,
        commission_value: String,
        expiration: Int,
        for_new_customers_only: Bool,
        imessage_autofill: String,
        is_public: Bool,
        minimum_spend: String,
        notes: String,
        link: String,
        offer_type: String,
        offer_value: String,                         //Convert to String
        product_ids: [String],
        referral_code_id: String,
        user_id: String
    ) {
        db.collection("referral_codes").document(referral_code_id)
            .setData([
                "brand_id": brand_id,
                "brand_name": brand_name,
                "code": code,
                "commission_type": commission_type,
                "commission_value": commission_value,
                "expiration": expiration,
                "for_new_customers_only": for_new_customers_only,
                "imessage_autofill": imessage_autofill,
                "is_public": is_public,
                "minimum_spend": minimum_spend,
                "notes": notes,
                "link": link,
                "offer_type": offer_type,
                "offer_value": offer_value,
                "product_ids": product_ids,
                "referral_code_id": referral_code_id,
                "user_id": user_id
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("IDK ERROR WHEN SUBMITTING??")
                }
            }
    }
    
    func updateMyReferralCode(
        brand_id: String,
        brand_name: String,
        code: String,
        commission_type: String,
        commission_value: String,
        expiration: Int,
        for_new_customers_only: Bool,
        imessage_autofill: String,
        is_public: Bool,
        minimum_spend: String,
        notes: String,
        link: String,
        offer_type: String,
        offer_value: String,                         //Convert to String
        product_ids: [String],
        referral_code_id: String,
        user_id: String
    ) {
        db.collection("referral_codes").document(referral_code_id)
            .updateData([
                "brand_id": brand_id,
                "brand_name": brand_name,
                "code": code,
                "commission_type": commission_type,
                "commission_value": commission_value,
                "expiration": expiration,
                "for_new_customers_only": for_new_customers_only,
                "imessage_autofill": imessage_autofill,
                "is_public": is_public,
                "minimum_spend": minimum_spend,
                "notes": notes,
                "link": link,
                "offer_type": offer_type,
                "offer_value": offer_value,
                "product_ids": product_ids,
                "referral_code_id": referral_code_id,
                "user_id": user_id
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("IDK ERROR WHEN SUBMITTING??")
                }
            }
    }
}
