//
//  PostView.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI

struct PostView: View {
    
    @ObservedObject var users_vm: UsersVM
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    var body: some View {
        
        VStack {
            
            Text("HEADER")
            
            PostStruct(post: post, path: $path)
            
            Text("FOOTER")
            
        }
        
        
    }
}
