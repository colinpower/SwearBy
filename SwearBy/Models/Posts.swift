//
//  Posts.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Posts: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var description: String
    var is_public: Bool
    var is_verified: Bool
    var post_id: String
    var purchase_id: String
    var user_id: String
    var timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case description
        case is_public
        case is_verified
        case post_id
        case purchase_id
        case user_id
        case timestamp
    }
}
