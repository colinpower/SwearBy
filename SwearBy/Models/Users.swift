//
//  Users.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Users: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var email: String
    var email_verified: Bool
    var friend_requests: [String]
    var friends_added: [String]
    var friends_list: [String]
    var name: Struct_Profile_Name
    var phone: String
    var phone_verified: Bool
    var user_id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case email_verified
        case friend_requests
        case friends_added
        case friends_list
        case name
        case phone
        case phone_verified
        case user_id
    }
}

struct Struct_Profile_Name: Codable, Hashable {

    var first: String
    var last: String
    var first_last: String

    enum CodingKeys: String, CodingKey {
        case first
        case last
        case first_last
    }
}
