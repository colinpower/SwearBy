//
//  Products.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Products: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var link: String
    var brand_id: String
    var product_id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case link
        case brand_id
        case product_id
    }
}
