//
//  ItemHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ItemHalfSheet: View {
    
    var purchase: Purchases
    
    @StateObject private var private_brand_vm = BrandsVM()
    @StateObject private var private_product_vm = ProductsVM()
    
    @State private var private_brandURL:String = ""
    @State private var private_productURL:String = ""
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            if purchase.verification_status == "VERIFIED" {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Verified purchase")
                }.padding(.top, 20)
            } else {
                Text("Not yet verified")
                    .padding(.top, 20)
            }
            
            HStack {
                
                if private_productURL != "" {
                    WebImage(url: URL(string: private_productURL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Rectangle()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text(private_product_vm.get_product_by_id.name)
                    HStack {
                        
                        if private_brandURL != "" {
                            WebImage(url: URL(string: private_brandURL)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                        }
                        
                        Text(private_brand_vm.get_brand_by_id.name)
                        
                    }
                }
                
                Spacer()
                
            }.padding(.horizontal)
                .padding(.top, 30)
            
            Spacer()
            
            Button {
                print(private_product_vm.get_product_by_id.link)
            } label: {
                
                Text("tap button to see the link")
                
            }
            
            Spacer()
            
            Link(destination: URL(string: private_product_vm.get_product_by_id.link)!) {
//            Link(destination: URL(string: "https://www.google.com")!) {
            
                
                HStack {
                    
                    Spacer()
                    
                    Text("View product")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                }
                .padding(.vertical)
                .background(Capsule().foregroundColor(.blue))
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(height: UIScreen.main.bounds.height / 2)
        .onAppear {
            
            self.private_brand_vm.getBrandById(brand_id: purchase.brand_id)
            self.private_product_vm.getProductById(product_id: purchase.product_id)
            
            let brandPath = "brand/" + purchase.brand_id + ".png"
            let productPath = "product/" + purchase.product_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(brandPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_brandURL = "\(url!)"
                }
            }
            
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
}

