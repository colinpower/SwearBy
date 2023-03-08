//
//  ReferralCodes.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ReferralCodes: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var brand_id: String
    var brand_name: String
    var code: String
    var commission_type: String
    var commission_value: String                    //Convert to String
    var expiration: Int
    var for_new_customers_only: Bool
    var imessage_autofill: String                   //Added
    var is_public: Bool                             //Added
    var minimum_spend: String                       //Added
    var notes: String                               //Added
    var link: String
    var offer_type: String
    var offer_value: String                         //Convert to String
    var product_ids: [String]
    var referral_code_id: String
    var user_id: String
    
    enum CodingKeys: String, CodingKey {
        case brand_id
        case brand_name
        case code
        case commission_type
        case commission_value
        case expiration
        case for_new_customers_only
        case imessage_autofill
        case is_public
        case minimum_spend
        case notes
        case link
        case offer_type
        case offer_value
        case product_ids
        case referral_code_id
        case user_id
    }
}
