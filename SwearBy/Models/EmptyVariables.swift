//
//  EmptyVariables.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation

class EmptyVariables {
    
    var empty_brand = Brands(name: "", website: "", brand_id: "")
    
    var empty_post = Posts(description: "", is_public: false, is_verified: false, post_id: "", product_id: "", purchase_id: "", user_id: "", timestamp: 0)
    
    var empty_purchase = Purchases(brand_id: "", product_id: "", purchase_id: "", user_id: "", verification_status: "")
    
    var empty_user = Users(email: "", email_verified: false, friend_requests: [], friends_added: [], friends_list: [], name: Struct_Profile_Name(first: "", last: "", first_last: ""), phone: "", phone_verified: false, user_id: "")
    
    var empty_preloaded_referral_program = PreloadedReferralPrograms(brand_id: "", brand_name: "", code: "", commission_type: "None", commission_value: "", expiration: 0, for_new_customers_only: false, minimum_spend: "", link: "", link_for_setup: "", offer_type: "None", offer_value: "", preloaded_referral_program_id: "", product_ids: [], steps: SetupReferralSteps(one: "", two: "", three: ""))
    
    var empty_referral_code = ReferralCodes(brand_id: "", brand_name: "", code: "", commission_type: "", commission_value: "", expiration: 0, for_new_customers_only: false, imessage_autofill: "", is_public: false, minimum_spend: "", notes: "", link: "", offer_type: "", offer_value: "", product_ids: [], referral_code_id: "", user_id: "")
    
}
