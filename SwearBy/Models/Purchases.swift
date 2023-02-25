//
//  Purchases.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Purchases: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var brand_id: String
    var product_id: String
    var purchase_id: String
    var user_id: String
    var verification_status: String                 // NOT_VERIFIED, IN_PROGRESS, VERIFIED
    
    enum CodingKeys: String, CodingKey {
        case brand_id
        case product_id
        case purchase_id
        case user_id
        case verification_status
    }
}
