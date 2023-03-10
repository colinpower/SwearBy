//
//  ExpandedPost.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import SwiftUI

struct ExpandedPost: View {
    
    @ObservedObject var users_vm: UsersVM
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    
                    // Header
                    HStack (alignment: .center) {
                        Spacer()
                        Text("Post")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    .frame(height: 44)
                    .padding(.top, 60)
                    .padding(.horizontal)
                    .padding(.horizontal, 4)
                    
                    
                    PostInFeed(users_vm: users_vm, post: post, path: $path, isNavigationLinkToSelfDisabled: true)
                        .padding(.bottom)
                    
                    Divider()
                    
                    private_post_details
                    
                    
                }
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    var private_post_details: some View {
        
        VStack {
            
            ExpandedPostDetailRow(icon: "infinity", title: "Has not been reposted")
            
            ExpandedPostDetailRow(icon: "bookmark", title: "Bookmarked 3 times")
            
            ExpandedPostDetailRow(icon: "link", title: "Product link used 14 times")
            
        }
    }
}


struct ExpandedPostDetailRow: View {
    
    var icon: String
    var title: String
    
    var body: some View {
        
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.vertical, 17)
//                }
                Spacer()
            }.frame(width: 36)
                .padding(.horizontal)
                .padding(.leading, 8)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top, 20)
                    .padding(.bottom, 21)
                Divider().foregroundColor(Color("text.gray"))
            }.frame(height: 60)
        }.frame(height: 60)
    }
}
