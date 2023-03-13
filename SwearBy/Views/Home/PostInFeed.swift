//
//  PostInFeed.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct PostInFeed: View {
    
    @ObservedObject var users_vm: UsersVM
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    @State var isNavigationLinkToSelfDisabled:Bool = false
    
    @StateObject private var private_users_vm = UsersVM()
    @StateObject private var private_posts_vm = PostsVM()
    @StateObject private var private_products_vm = ProductsVM()
    
    @State private var user_image_URL:String = ""
    @State private var post_image_URL:String = ""
    @State private var product_image_URL:String = ""
    
    @State private var isShowingProductHalfSheet:Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Button {
                path.append(private_users_vm.get_user_by_id)
            } label: {
                miniProfile             // 36 in height after padding
            }
            
            Button {
                if isNavigationLinkToSelfDisabled {
                    
                } else {
                    path.append(post)
                }
            } label: {
                    
                let new_width:CGFloat = UIScreen.main.bounds.width
                let new_height:CGFloat = UIScreen.main.bounds.width
                
                VStack(spacing: 0) {
                    
                    // Image
                    
                    if post_image_URL != "" {
                        WebImage(url: URL(string: post_image_URL)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: new_width, height: new_height)
                    } else {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: new_width, height: new_height)
                    }
                }
                .frame(width: new_width, height: new_height)
            }
             
            Button {
                isShowingProductHalfSheet.toggle()
            } label: {
                productInThisPost
            }
            
            description
                .padding(.top, 10)
            
        }
        .onAppear {
            
            self.private_users_vm.getUserByID(user_id: post.user_id)
            self.private_products_vm.getProductById(product_id: post.product_id)
            
            let backgroundPath = "post/" + post.post_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.post_image_URL = "\(url!)"
                }
            }
        }
        .sheet(isPresented: $isShowingProductHalfSheet) {
            ItemHalfSheet(post: post, brand_id: private_products_vm.get_product_by_id.brand_id)
                .presentationDetents([.fraction(CGFloat(0.7))])
                .presentationDragIndicator(.visible)
        }
    }
    
    var miniProfile: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            if user_image_URL != "" {
                WebImage(url: URL(string: user_image_URL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.gray)
            }
            
            Text(private_users_vm.get_user_by_id.name.first_last)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Color.black)
                .padding(.leading, 8)
            
            Spacer()
            
        }.padding(.horizontal).padding(.vertical, 10)
        .onAppear {
            
            let backgroundPath = "user/" + post.user_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.user_image_URL = "\(url!)"
                }
            }
            
            
        }
        
    }
    
    var productInThisPost: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Shop this post")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.vertical, 10)
            
            if product_image_URL != "" {
                WebImage(url: URL(string: product_image_URL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color("TextFieldGray")))
                
            } else {
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(Color("TextFieldGray"))
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text("Image not found")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            let backgroundPath = "product/" + post.product_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.product_image_URL = "\(url!)"
                }
            }
        }
    }
    
    
    
    var description: some View {
        
        Button {
            if isNavigationLinkToSelfDisabled {
                
            } else {
                path.append(post)
            }
        } label: {
            Text(post.description)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
                .multilineTextAlignment(.leading)
                .lineLimit(isNavigationLinkToSelfDisabled ? nil : 2)
                .padding(.horizontal)
                .padding(.horizontal, 4)
        }
    }
}

//inThisPost
