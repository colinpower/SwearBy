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
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    @StateObject var posts_vm = PostsVM()
    
    @State private var path = NavigationPath()
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            NavigationStack(path: $path) {
                
                VStack(spacing: 0) {
                    
                    PrimaryHeader(users_vm: users_vm, title: "Home", fullScreenModalPresented: $fullScreenModalPresented)
                    
                    ScrollView(showsIndicators: false) {
                    
                        VStack(alignment: .center) {
                            ForEach(posts_vm.posts_in_user_feed) { post in
                                
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
            MyTabView(users_vm: users_vm, selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            self.posts_vm.listenForPostsInUserFeed(users_vm: users_vm)
            
        }
        .fullScreenCover(item: $fullScreenModalPresented, onDismiss: { fullScreenModalPresented = nil }) { sheet in
    
            switch sheet {        //add_friends, add_code, add_preloaded_code
            case .add_friends:
                AddFriends(users_vm: users_vm)
            case .add_post:
                AddPost(users_vm: users_vm)
            default:
                AddFriends(users_vm: users_vm)
            }
        }

    }
}
