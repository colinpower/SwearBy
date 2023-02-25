//
//  Home.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @StateObject var posts_vm = PostsVM()
    
    @State private var presentedSheet: PresentedSheet? = nil
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {

            VStack {
                
                header
                
                ScrollView {
                    
                    ForEach(posts_vm.all_posts) { post in
                        
                        Button {
                            
                            path.append(post)
                            
                        } label: {
                            
                            
                            //Text("alsdkfjsld")
                            PostStruct(post: post, path: $path)
                            
                        }
                        
                        
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                
                self.posts_vm.getAllPosts()
                
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Posts.self) { post in
                PostView(users_vm: users_vm, post: post, path: $path)
            }
            .navigationDestination(for: Users.self) { user in
                Profile(users_vm: users_vm)
            }
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
