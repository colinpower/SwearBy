//
//  PostStruct.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct PostStruct: View {
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    @ObservedObject private var private_users_vm = UsersVM()
    @State private var private_backgroundURL:String = ""
    
    var body: some View {
        
        VStack {
            
            header
            
            
            
            
        }
    }
    
    var header: some View {
        
        
        HStack {
            
            Button {
                
                path.append(private_users_vm.get_user_by_id)
                
            } label: {
                
                HStack {
                    Circle().frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    
                    Text(post.user_id)
                }
            }
            
        }.padding()
            .onAppear {
                
                self.private_users_vm.getUserByID(user_id: post.user_id)
                
                
            }
        
    }
    
    var image: some View {
        
        VStack {
            if private_backgroundURL != "" {
                WebImage(url: URL(string: private_backgroundURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing)
            } else {
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
            
            
        }
        .onAppear {
            
            let backgroundPath = "post/" + post.post_id + "/image.png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_backgroundURL = "\(url!)"
                }
            }
        }
        
        
    }
}
