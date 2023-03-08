//
//  PreloadedReferralPrograms.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PreloadedReferralPrograms: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var brand_id: String
    var brand_name: String                          //Added
    var code: String
    var commission_type: String
    var commission_value: String                    //Convert from Int to String
    var expiration: Int
    var for_new_customers_only: Bool
    var minimum_spend: String                       //Added
    var link: String
    var link_for_setup: String
    var offer_type: String
    var offer_value: String                         //Convert from Int to String
    var preloaded_referral_program_id: String
    var product_ids: [String]
    var steps: SetupReferralSteps
    
    enum CodingKeys: String, CodingKey {
        case brand_id
        case brand_name
        case code
        case commission_type
        case commission_value
        case expiration
        case for_new_customers_only
        case minimum_spend
        case link
        case link_for_setup
        case offer_type
        case offer_value
        case preloaded_referral_program_id
        case product_ids
        case steps
    }
}


struct SetupReferralSteps: Codable, Hashable {

    var one: String
    var two: String
    var three: String

    enum CodingKeys: String, CodingKey {
        case one
        case two
        case three
    }
}
