//
//  FriendProfile.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct FriendProfile: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var path: NavigationPath
    var friend_user: Users
    
    @StateObject private var private_friends_posts_vm = PostsVM()
    @StateObject private var private_friends_user_vm = UsersVM()
    
    @State private var private_friend_profile_ImageURL:String = ""
    
    let columns: [GridItem] = [
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 32), spacing: 16, alignment: nil),
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 32), spacing: 16, alignment: nil)
            ]

    var body: some View {
        
        VStack(spacing: 0) {
            
            // Header
            HStack (alignment: .center) {
                Spacer()
                Text(friend_user.name.first + "'s Profile")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                Spacer()
            }
            .padding(.bottom, 4)
            .frame(height: 44)
            .padding(.top, 60)
            .padding(.horizontal)
            .padding(.horizontal, 4)
            
            friendProfileTopSection
                .padding(.vertical)

            friendProfileButtons
                .padding(.vertical)
                .padding(.bottom)

            ScrollView(showsIndicators: false) {

                VStack (alignment: .center, spacing: 0) {

                    HStack (spacing: 0) {
                        Text("Things \(friend_user.name.first) Swears By")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                            .padding(.bottom, 4)
                        Spacer()
                    }
                    .padding(.bottom)

                    LazyVGrid(columns: columns, spacing: 16) {

                        ForEach(private_friends_posts_vm.one_user_posts) { post in

                            Button {

                                path.append(post)

                            } label: {
                                ProfilePostWidget(post: post)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                                .stroke(lineWidth: 1)
                                                                .foregroundColor(Color("TextFieldGray")))
                            }
                        }
                    }.padding(.bottom, 100)
                }

            }.padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            self.private_friends_posts_vm.getOneUserPosts(user_id: friend_user.user_id)
            
            self.private_friends_user_vm.getUserByID(user_id: friend_user.user_id)
            
            let storage = Storage.storage().reference()
            
            let userPath = "user/" + friend_user.user_id + ".png"
            
            storage.child(userPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_friend_profile_ImageURL = "\(url!)"
                }
            }
            
        }
    }
    
    var friendProfileTopSection: some View {
        
        // Image, Name, Num of friends
        HStack(alignment: .top, spacing: 0) {
            
            if private_friend_profile_ImageURL != "" {
                WebImage(url: URL(string: private_friend_profile_ImageURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
            }
                    
            VStack(alignment: .leading, spacing: 0) {
                    
                Text(friend_user.name.first_last)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.bottom, 8)
                    
                HStack(spacing: 0) {
                    
                    let num_friends = private_friends_user_vm.get_user_by_id.friends_list.isEmpty ? 0 : private_friends_user_vm.get_user_by_id.friends_list.count
                    let num_posts = private_friends_posts_vm.one_user_posts.isEmpty ? 0 : private_friends_posts_vm.one_user_posts.count
                    
                    Text(String(num_friends))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Text(num_friends == 1 ? " Friend" : " Friends")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.trailing)
                    
                    Text(String(num_posts))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Text(num_posts == 1 ? " Post" : " Posts")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Spacer()
                    
                }
                    
                    
            }.padding(.leading).padding(.leading).padding(.vertical)
            
        }.padding(.horizontal)
    }
    
    var friendProfileButtons: some View {
            
        // Settings, Share Profile
        HStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center) {
                Spacer()
                
                Text("Friends")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                
                Spacer()
            }
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("TextFieldGray")))
            .padding(.horizontal)
            
            ShareLink(item: "Hey, check out \(friend_user.name.first_last)'s profile on SwearBy app! <insert URL here>", preview: SharePreview(
                "Join me on SwearBy!",
                image: Image("AppIcon"))) {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Text(" Share ")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.green))
                    
                }.padding(.horizontal)
            
        }
    }
}




