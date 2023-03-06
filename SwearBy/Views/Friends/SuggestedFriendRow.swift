//
//  SuggestedFriendRow.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//

import SwiftUI

struct SuggestedFriendRow: View {
    
    var friend_phone_number: String
    
    @StateObject var lookup_number_users_vm = UsersVM()
    
    var body: some View {
        
        let found_friend: Users = lookup_number_users_vm.get_users_by_phone_number.first ?? EmptyVariables().empty_user
        
        HStack(alignment: .center, spacing: 0) {
            
            //The Circle + Letter for each contact
            ZStack(alignment: .center) {
                Circle().frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text(found_friend.name.first.prefix(1))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
                .padding(.trailing, 16)
            
            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {
                
                Text(found_friend.name.first_last)
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding(.bottom, 6)
                Text(found_friend.phone)
                    .foregroundColor(Color("text.gray"))
                    .font(.system(size: 16, weight: .regular))
            }
            
            Spacer()
            
            Button {

                // Send a friend request

            } label: {

                ZStack(alignment: .center) {
                    Capsule()
                        .frame(width: 80, height: 32)
                        .foregroundColor(Color("ShareGray"))
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill.badge.plus")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                        Text("Add")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                    }
                }
            }

                                        
        }
        .padding(.vertical, 12)
        .onAppear {
            
            self.lookup_number_users_vm.getUserByPhoneNumber(number: friend_phone_number)
            
        }
    }
}

