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
                                //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width + 44)
                                //PostStruct(post: post, path: $path)
                                
                            }
                        }.padding(.bottom).padding(.bottom)
                    }
                }
                    
                }
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Posts.self) { post in
                    PostView(users_vm: users_vm, post: post, path: $path)
                }
                .navigationDestination(for: Users.self) { user in
                    FriendProfile(users_vm: users_vm, path: $path)
                }
                .navigationDestination(for: Purchases.self) { purchase in
                    ItemHalfSheet(purchase: purchase)
                    //TestSheet()
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
    
    
    private var header: some View {
        
        HStack (alignment: .center) {
            
            Text("What I Swear By")
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
            
//            Button {
//
//                presentedSheetOnHome2 = .add
//
//            } label: {
//
//                Image(systemName: "plus.circle.fill")
//                    .font(.system(size: 24))
//
//            }
            
        }.padding(.top, 48)
        .padding()
    }
}

//decide which view to present
enum PresentedSheet: String, Identifiable {
    case purchase
    var id: String {
        return self.rawValue
    }
}
