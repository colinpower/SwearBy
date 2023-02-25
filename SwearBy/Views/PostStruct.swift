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
    @State private var private_purchaseURL:String = ""
    @State private var is_showing_half_sheet: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            header
            
            image
            
            purchase_linked
            
            
        }
        .sheet(isPresented: $is_showing_half_sheet) {
            
            VStack {
                Spacer()
                Text(post.purchase_id)
                Spacer()
            }
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
                    Spacer()
                }
            }
            
        }.padding()
            .onAppear {
                
                self.private_users_vm.getUserByID(user_id: post.user_id)
                
                
            }
        
    }
    
    var image: some View {
        
        VStack(alignment: .leading) {
            if private_backgroundURL != "" {
                WebImage(url: URL(string: private_backgroundURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 4)
            } else {
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
            }
            
            Text(post.description).multilineTextAlignment(.leading)
                .frame(alignment: .topLeading)
            
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
    
    var purchase_linked: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                VStack {
                    Divider()
                }
                Text("Shop verified purchases")
                    .foregroundColor(.black)
                VStack {
                    Divider()
                }
            }.padding(.horizontal)
            
            if private_backgroundURL != "" {
                
                Button {
                    
                    is_showing_half_sheet = true
                    
                } label: {
                    WebImage(url: URL(string: private_purchaseURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            } else {
                Button {
                    
                    is_showing_half_sheet = true
                    
                } label: {
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            
            let backgroundPath = "product/" + post.product_id + "/image.png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_purchaseURL = "\(url!)"
                }
            }
        }
        
        
    }
}
