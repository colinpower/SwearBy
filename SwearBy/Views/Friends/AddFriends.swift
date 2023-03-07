//
//  AddFriends.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import SwiftUI

struct AddFriends: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var users_vm: UsersVM
    
    @StateObject var contactsVM = ContactsViewModel()
    
    @State var isShowingContactsList:Bool = false
    @State var selectedContact:[String] = ["", "Your Friend's", "Name", ""]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            VStack(spacing: 0) {
                
                addFriendsHeader
                
                ScrollView(showsIndicators: false) {
                    
                    myShareLink
                        .padding(.vertical)
                    
                    if true {
                        addedMe
                            .padding(.bottom)
                    }
                                        
                    if true {
                        contactsOnSwearBy
                            .padding(.bottom)
                    }
                    
                    if true {
                        myFriends
                            .padding(.bottom)
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color("Background"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Users.self) { user in
                FriendProfile(users_vm: users_vm, path: $path, friend_user: user)
            }
            .sheet(isPresented: $isShowingContactsList) {
                isShowingContactsList = false
            } content: {
                ContactsView(isShowingContactsList: $isShowingContactsList, selectedContact: $selectedContact)
            }
        }
    }
    
    
    var myShareLink: some View {
        
        
        ShareLink(item: "Hey, join me on SwearBy app! <insert URL here>", preview: SharePreview(
            "Join me on SwearBy!",
            image: Image("AppIcon"))) {
            
            HStack(alignment: .center, spacing: 0) {
                
                Image("SwearByIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.trailing, 16)
                
                Text("Share your link")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                
                Spacer()
                
                Image(systemName: "message")
                    .foregroundColor(.green)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 8)
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
        }
    }
    
    var addedMe: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack (spacing: 0) {
                Text("Added Me")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.bottom, 4)
                Spacer()
            }
            
            Group {
                ForEach(users_vm.one_user.friend_requests, id: \.self) { friend_id in
                    
                    if friend_id != "" {
                        AcceptFriendRow(users_vm: users_vm, friend_user_id: friend_id)
                    }
                    
                }
            }
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
        }
    }
    
    var contactsOnSwearBy: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack (spacing: 0) {
                Text("My Friends on SwearBy")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.bottom, 4)
                Spacer()
            }
            
            let arrayOfUsersPhoneNumbersOnSwearBy = users_vm.all_users.map { $0.phone }
            
            Group {
                ForEach(contactsVM.contacts.filter {
                    ($0.firstName.count > 0 &&
                     $0.phone?.count ?? 0 > 0 &&
                     $0.firstName.prefix(1) != "#"
                    )
                    
                }) { contact in
                    
                    if checkForExistingUserBasedOnPhoneNumber(existingUsers: arrayOfUsersPhoneNumbersOnSwearBy, contact: contact) {
                        
                        let contact_phone = contact.phone ?? ""
                        let numberWithNumbersOnly = contact_phone.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+1", with: "")
                        
                        SuggestedFriendRow(users_vm: users_vm, friend_phone_number: numberWithNumbersOnly)
                        
                    }
                }
            }.padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))

        }
        .onAppear {
            
            self.users_vm.getAllUsers()
            
        }
    }
    
    var myFriends: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack (spacing: 0) {
                Text("My Friends")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.bottom, 4)
                Spacer()
            }
            
            Group {
                ForEach(users_vm.one_user.friends_list, id: \.self) { friend_id in
                    
                    if friend_id != "" {
                        
                        FriendRow(friend_user_id: friend_id, path: $path)

                    }
                    
                }
            }
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
        }
    }
    
    var addFriendsHeader: some View {

        HStack (alignment: .center) {
            
            
            Button {

                dismiss()

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Background"))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
            }
            
            Spacer()
            Text("Add Friends")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 40)
            Spacer()
            
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
    
    
    
    func checkForExistingUserBasedOnPhoneNumber(existingUsers: [String], contact: Contact) -> Bool {
        
        if let number = contact.phone {
            
            let numberWithNumbersOnly = number.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+1", with: "")
            
            if existingUsers.contains(numberWithNumbersOnly) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

