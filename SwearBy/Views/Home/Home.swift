//
//  Home.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var selectedTab: Int
    
    @StateObject var posts_vm = PostsVM()
    
    @State private var path = NavigationPath()
    
    @State var isShowingAddFriendsPage: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            NavigationStack(path: $path) {
                
                VStack(spacing: 0) {
                    
                    PrimaryHeader(title: "Home", isShowingAddFriendsPage: $isShowingAddFriendsPage)
                    
                    ScrollView(showsIndicators: false) {
                    
                        VStack(alignment: .center) {
                            ForEach(posts_vm.all_posts) { post in
                                
                                Button {
                                    
                                    path.append(post)
                                    
                                } label: {
                                    
                                    LargePostCondensed(post: post, path: $path)
                                    
                                }
                            }
                        }.padding(.bottom, 100)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Posts.self) { post in
                    PostView(users_vm: users_vm, post: post, path: $path)
                }
                .navigationDestination(for: Users.self) { user in
                    FriendProfile(users_vm: users_vm, path: $path, friend_user: user)
                }
            }
            MyTabView(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            self.posts_vm.getAllPosts()
            
        }
        .fullScreenCover(isPresented: $isShowingAddFriendsPage) {
            AddFriends(isShowingAddFriendsPage: $isShowingAddFriendsPage)
        }
    }
}
