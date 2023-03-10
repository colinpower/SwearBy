//
//  FriendRow.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


struct FriendRow: View {
    
    var friend_user_id: String
    
    @Binding var path: NavigationPath
    
    @StateObject private var lookup_users_vm = UsersVM()
    
    @State private var friend_profileURL: String = ""
    
    var body: some View {
        Group {
            Button {
                path.append(lookup_users_vm.get_user_by_id)
            } label : {
                HStack(alignment: .center, spacing: 0) {
                    
                    if friend_profileURL != "" {
                        WebImage(url: URL(string: friend_profileURL)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.trailing, 16)
                    } else {
                        ZStack(alignment: .center) {
                            Circle().frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Text(lookup_users_vm.get_user_by_id.name.first.prefix(1))
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                        }.padding(.trailing, 16)
                    }

                    
                    //The first + last names and the phone number
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(lookup_users_vm.get_user_by_id.name.first_last)
                            .foregroundColor(Color("text.black"))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.bottom, 6)
                        
                        if lookup_users_vm.get_user_by_id.friends_list.count == 1 {
                            Text(String(lookup_users_vm.get_user_by_id.friends_list.count) + " Friend")
                                .foregroundColor(Color("text.gray"))
                                .font(.system(size: 16, weight: .regular))
                        } else {
                            Text(String(lookup_users_vm.get_user_by_id.friends_list.count) + " Friends")
                                .foregroundColor(Color("text.gray"))
                                .font(.system(size: 16, weight: .regular))
                        }
                    }
   
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    
                }
                .padding(.vertical, 12)
            }
        }
        .onAppear {
            
            self.lookup_users_vm.getUserByID(user_id: friend_user_id)
                    
            let backgroundPath = "user/" + friend_user_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.friend_profileURL = "\(url!)"
                }
            }
            
            
            
        }
    }
}

