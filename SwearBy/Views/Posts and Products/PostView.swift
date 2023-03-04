//
//  PostView.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct PostView: View {
    
    @ObservedObject var users_vm: UsersVM
    
    var post: Posts
    
    @Binding var path: NavigationPath
    
    @StateObject private var private_product_vm = ProductsVM()
    @StateObject private var private_user_vm = UsersVM()
    
    @State private var private_productURL:String = ""
    @State private var private_userImageURL:String = ""
    
    @State private var didMarkStar:Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            productImageAndButtons
                .padding(.bottom)
                .padding(.bottom)
            
            //descriptionFromUser
            
            HStack {
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("Save")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical)
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(Capsule().foregroundColor(Color.blue))
                
                Spacer()
            
                Link(destination: URL(string: private_product_vm.get_product_by_id.link)!) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Shop this product")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(Color.blue))
                    
                }
                
            }.padding(.horizontal)
                .padding(.bottom)
                .padding(.bottom)
            
            Divider()
            
            
            Text(post.description)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .padding(.horizontal)
                .padding(.vertical)
                .padding(.vertical)
            
            Divider()
            
            
            
            
            
            
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            self.private_product_vm.getProductById(product_id: post.product_id)
            
            let storage = Storage.storage().reference()
            
            let productPath = "product/" + post.product_id + ".png"
            
            storage.child(productPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_productURL = "\(url!)"
                }
            }
        }
    }
    
    var productImageAndButtons: some View {
        
        ZStack(alignment: .center) {
            
            if private_productURL != "" {
                WebImage(url: URL(string: private_productURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            }
            
            VStack(spacing: 0) {
                
                Spacer()
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(private_product_vm.get_product_by_id.name)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundColor(Color("text.gray"))
                            .padding(.bottom, 4)

                        Text(private_product_vm.get_product_by_id.brand_id)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                            .padding(.bottom, 8)
                    }.padding(.leading)

                    Spacer()

                }.background(Rectangle().frame(width: UIScreen.main.bounds.width).padding(.top, 5).foregroundColor(Color("TextFieldGray").opacity(0.7)))
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
    }
    
}








//self.private_user_vm.getUserByID(user_id: post.user_id)
//
//storage.child(userPath).downloadURL { url, err in
//    if err != nil {
//        print(err?.localizedDescription ?? "Issue showing the right image")
//        return
//    } else {
//        self.private_userImageURL = "\(url!)"
//    }
//}

//let userPath = "user/" + post.user_id + ".png"
