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
    
    
    @StateObject private var private_tab_bar_preloaded_referral_program_vm = PreloadedReferralProgramVM()
    @State private var private_tab_bar_preloaded_referral_program = EmptyVariables().empty_preloaded_referral_program
    
    var body: some View {
        VStack(spacing: 0) {
            
            NavigationStack(path: $path) {
                
                VStack(spacing: 0) {
                    
                    PrimaryHeader(users_vm: users_vm, title: "Home", fullScreenModalPresented: $fullScreenModalPresented)
                    
                    ScrollView(showsIndicators: false) {
                    
                        VStack(alignment: .center) {
                            ForEach(posts_vm.posts_in_user_feed) { post in
                                
                                
                                    
                                PostInFeed(users_vm: users_vm, post: post, path: $path)
                                    .padding(.bottom, 60)
                                Divider()
                                    .padding(.bottom, 20)
                                    //LargePostCondensed(post: post, path: $path, fullScreenModalPresented: $fullScreenModalPresented)
                                    
//                                }
                            }
                        }.padding(.bottom, 100)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Posts.self) { post in
                    ExpandedPost(users_vm: users_vm, post: post, path: $path)
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
            case .add_code:
                AddNewCode(users_vm: users_vm, preloaded_referral_programs_vm: private_tab_bar_preloaded_referral_program_vm, preloaded_referral_program: $private_tab_bar_preloaded_referral_program)
            default:
                AddFriends(users_vm: users_vm)
            }
        }

    }
}




//struct TriggerHalfSheet: View {
//
//    @Binding var fullScreenModalPresented: FullScreenModalPresented?
//
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var users_vm: UsersVM
//
//    @State var type_selected:Int = 0
//
//    var body: some View {
//
//        ZStack(alignment: .bottomTrailing) {
//            if type_selected == 0 {
//                CreatePost(users_vm: users_vm)
//            } else {
//                CreateRequest()
//            }
//
//            ZStack(alignment: .center) {
//
//                Capsule()
//                    .foregroundColor(.blue)
//                    .frame(width: UIScreen.main.bounds.width / 2, height: 60)
//
//                HStack {
//                    Spacer()
//                    Button {
//                        type_selected = 0
//                    } label: {
//                        Text(" Post ")
//                            .font(.system(size: 16, weight: .medium, design: .rounded))
//                            .foregroundColor(Color.white)
//                            .padding(.horizontal, 4)
//                    }
//                    Spacer()
//                    Button {
//                        type_selected = 1
//                    } label: {
//                        Text("Request")
//                            .font(.system(size: 16, weight: .medium, design: .rounded))
//                            .foregroundColor(Color.white)
//                            .padding(.horizontal, 4)
//                    }
//                    Spacer()
//                }
//
//
//
//            }
//        }
//    }
//
//}
