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
    
    
    @StateObject private var private_posts_vm = PostsVM()
    @StateObject private var private_user_vm = UsersVM()
    
    
    @State private var private_userImageURL:String = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack (spacing: 0) {
                                
                if private_userImageURL != "" {
                    WebImage(url: URL(string: private_userImageURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)

                }
                
                VStack {
                    
                    Text(friend_user.name.first_last)
                    
                    Text("14 friends")
                    
                }
            }
            
            HStack {
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("Friends")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical)
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(Capsule().foregroundColor(Color.green))
                
                Spacer()
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("Share Profile")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical)
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(Capsule().foregroundColor(Color.blue))
                
            }
            
            ScrollView(showsIndicators: false) {
            
                VStack(alignment: .center) {
                    ForEach(private_posts_vm.one_user_posts) { post in
                        
                        Button {
                            
                            path.append(post)
                            
                        } label: {
                            
                            LargePostCondensed(post: post, path: $path)
                            
                        }
                    }
                }.padding(.bottom, 100)
            }
                
                
            
        }
        .onAppear {
            
            self.private_posts_vm.getOneUserPosts(user_id: friend_user.user_id)
            
            self.private_user_vm.getUserByID(user_id: friend_user.user_id)
            
            let storage = Storage.storage().reference()
            
            let userPath = "user/" + friend_user.user_id + ".png"
            
            storage.child(userPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_userImageURL = "\(url!)"
                }
            }
            
        }
        
    }
}


