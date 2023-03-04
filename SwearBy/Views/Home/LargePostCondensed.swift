//
//  LargePostCondensed.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct LargePostCondensed: View {
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    @StateObject private var private_users_vm = UsersVM()
    @StateObject private var private_purchases_vm = PurchasesVM()
    @StateObject private var private_posts_vm = PostsVM()
    
    @State private var private_userImageURL:String = ""
    @State private var private_purchaseURL:String = ""      //GET RID OF THIS
    @State private var private_profileURL:String = ""
    
    @State private var didMarkStar:Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Group {
                
                GeometryReader { geometry in
                    
                    ZStack(alignment: .center) {
                        
                        if private_userImageURL != "" {
                            WebImage(url: URL(string: private_userImageURL)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 0) {
                            
                            VStack(spacing: 0) {
                                
                                Spacer()
                                
                                Button {
                                    path.append(private_users_vm.get_user_by_id)
                                } label: {
                                    miniProfile
                                }
                                
                            }.frame(height: geometry.size.width)
                            
                            VStack(spacing: 10) {
                                
                                Spacer()
                                
                                Button {
                                    path.append(private_purchases_vm.get_purchase_by_id)
                                } label: {
                                    SleekButton(icon_name: "bag.fill")
                                }
                                
                                Button {
                                    
                                } label: {
                                    SleekButton(icon_name: "star.fill")
                                }
                                
                                Button {
                                    
                                } label: {
                                    SleekButton(icon_name: "paperplane.fill")
                                }
                                

                            }.padding(.bottom, 10)
                                .frame(height: geometry.size.width)
                            
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 20)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            
            description
            
        }
        
        .onAppear {
            
            self.private_users_vm.getUserByID(user_id: post.user_id)
            self.private_purchases_vm.getPurchaseById(purchase_id: post.purchase_id)
            
            let backgroundPath = "post/" + post.post_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_userImageURL = "\(url!)"
                }
            }
        }
    }
    
    var miniProfile: some View {
        
        HStack(spacing: 0) {
            
            if private_profileURL != "" {
                WebImage(url: URL(string: private_profileURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(private_users_vm.get_user_by_id.name.first_last)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                Text(convertTimestampToShortDate(timestamp: post.timestamp))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
            }.padding(.leading, 8)
            
            Spacer()
            
        }
        .onAppear {
            
            let backgroundPath = "user/" + post.user_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_profileURL = "\(url!)"
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
    
    var description: some View {
        
        Button {
            path.append(post)
        } label: {
            Text(post.description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("text.black"))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding(.horizontal)
                .padding(.horizontal, 4)
        }
    }
    
}


struct SleekButton: View {
    
    var icon_name: String
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(Color.white.opacity(0.43))
            Image(systemName: icon_name)
                .foregroundColor(Color.white)
        }
        
    }
}
