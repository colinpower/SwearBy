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
    
    @StateObject private var private_users_vm = UsersVM()
    @StateObject private var private_purchases_vm = PurchasesVM()
    @StateObject private var private_posts_vm = PostsVM()
    
    @State private var private_backgroundURL:String = ""
    @State private var private_purchaseURL:String = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            header
            
            image
            
            purchase_linked
            
        }
//        .sheet(item: $showingHalfSheet, onDismiss: { showingHalfSheet = nil }) { [selected_purchase] sheet in
//
//            switch sheet {        // .purchases, ... (?)
//
//            case .purchase:
//                ItemHalfSheet(purchase: selected_purchase)
//                    .presentationDetents([.medium])
//                    .presentationDragIndicator(.visible)
//            }
//        }
        .onAppear {
            
            print("THIS IS THE POST PASSED")
            print("THIS IS THE POST THAT EXISTS NOW")
            
            self.private_purchases_vm.getPurchaseById(purchase_id: post.purchase_id)
            
            
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
            
        }
        .padding()
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
            
            let backgroundPath = "post/" + post.post_id + ".png"
            
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
            
            Button {

                //selected_purchase = private_purchases_vm.get_purchase_by_id

                print("THIS IS THE PURCHASE PASSED")
                let temp_purchase = private_purchases_vm.get_purchase_by_id
                
                print(temp_purchase)
                
                
                path.append(temp_purchase)
                //showingHalfSheet = .purchase
            } label: {
//                if private_backgroundURL != "" {
//
//                    WebImage(url: URL(string: private_purchaseURL)!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 60, height: 60)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//
//                } else {
                    
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
//                }
            }
        }
        .onAppear {
            
            let backgroundPath123 = "product/" + post.product_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath123).downloadURL { url, err in
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

