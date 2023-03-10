//
//  SuggestedFriendRow.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//

import SwiftUI

struct SuggestedFriendRow: View {
    
    @ObservedObject var users_vm: UsersVM
    
    var friend_phone_number: String
    
    var contact: Contact
    
    @StateObject var lookup_number_users_vm = UsersVM()
    
    var body: some View {
        
        let found_friend: Users = lookup_number_users_vm.get_users_by_phone_number.first ?? EmptyVariables().empty_user
        let my_friend_requests = users_vm.one_user.friend_requests
        let my_friends_list = users_vm.one_user.friends_list
        
        Group {
            if ((my_friend_requests.contains(found_friend.user_id)) || (my_friends_list.contains(found_friend.user_id))) {
                EmptyView()
            } else {
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
                        
                        Text(contact.firstName + " " + contact.lastName)
                            .foregroundColor(Color("text.black"))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.bottom, 6)
//                        Text(contact.firstName + " " + contact.lastName)
//                            .foregroundColor(Color("text.black"))
//                            .font(.system(size: 16, weight: .semibold, design: .rounded))
//                            .padding(.bottom, 3)
                        Text(makePhoneNumberPretty(phone_number: found_friend.phone))
                            .foregroundColor(Color("text.gray"))
                            .font(.system(size: 16, weight: .regular))
                    }
                    
                    Spacer()
                    
                    if users_vm.one_user.friends_added.contains(found_friend.user_id) {
                        
                        ZStack(alignment: .center) {
                            
                            Capsule()
                                .strokeBorder(.green, lineWidth: 2)
                                .frame(width: 80, height: 32)
                            Text("Sent")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.green)
                        }
                        
                    } else {
                        
                        Button {
                            
                            users_vm.sendFriendRequest(my_user_object: users_vm.one_user, my_friends_user_object: found_friend)
                            
                        } label: {
                            
                            ZStack(alignment: .center) {
                                
                                Capsule()
                                    .frame(width: 80, height: 32)
                                    .foregroundColor(Color("ShareGray"))
                                HStack(alignment: .center, spacing: 6) {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color("text.gray"))
                                    Text("Add")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color("text.gray"))
                                }
                            }
                        }
                        
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .onAppear {
            
            print(friend_phone_number)
            
            self.lookup_number_users_vm.getUserByPhoneNumber(number: friend_phone_number)
            
        }
    }
}
