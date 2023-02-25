//
//  Brands.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Brands: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var website: String
    var brand_id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case website
        case brand_id
    }
}
