//
//  FriendRow.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//
import SwiftUI

struct FriendRow: View {
    
    var friend_user_id: String
    
    @StateObject private var lookup_users_vm = UsersVM()
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            //The Circle + Letter for each contact
            ZStack(alignment: .center) {
                Circle().frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text(lookup_users_vm.get_user_by_id.name.first.prefix(1))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
                .padding(.trailing, 16)
            
            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {
                
                Text(lookup_users_vm.get_user_by_id.name.first_last)
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding(.bottom, 6)
                Text(lookup_users_vm.get_user_by_id.phone)
                    .foregroundColor(Color("text.gray"))
                    .font(.system(size: 16, weight: .regular))
            }
            
            Spacer()

                                        
        }
        .padding(.vertical, 12)
        .onAppear {
            
            self.lookup_users_vm.getUserByID(user_id: friend_user_id)
            
        }
    }
}

