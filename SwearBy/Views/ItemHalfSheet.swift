//
//  ItemHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI



//    .shadow(color: Color.red, radius: 10, x: 5, y: 5)

struct ItemHalfSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var post: Posts
    var brand_id: String
    
    @StateObject private var private_brand_vm = BrandsVM()
    @StateObject private var private_product_vm = ProductsVM()
    @StateObject private var private_purchase_vm = PurchasesVM()
    
    @State private var brand_image_URL:String = ""
    @State private var product_image_URL:String = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            

            VStack(spacing: 0) {
                
                if product_image_URL != "" {
                    WebImage(url: URL(string: product_image_URL)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color("TextFieldGray")))
                    
                } else {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(Color("TextFieldGray"))
                            .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Image not found")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                
                Text(private_product_vm.get_product_by_id.name)
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.bottom, 10)
                    .padding(.top)
                    .padding(.top)
                
                HStack {
                    if brand_image_URL != "" {
                        WebImage(url: URL(string: brand_image_URL)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                    
                    Text(private_brand_vm.get_brand_by_id.name)
                        .foregroundColor(Color("text.black"))
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                }.padding(.bottom)
                    .padding(.bottom)
                
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: private_purchase_vm.get_purchase_by_id.verification_status == "VERIFIED" ? "checkmark.seal.fill" : "checkmark.seal")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .padding(.trailing, 3)
                    Text(private_purchase_vm.get_purchase_by_id.verification_status == "VERIFIED" ? "Verified Purchase" : "Purchase Not Verified")
                        .font(.system(size: 11, weight: .regular))
                }.foregroundColor(private_purchase_vm.get_purchase_by_id.verification_status == "VERIFIED" ? Color.green : Color("text.gray"))
                
            }
            .padding()
            .padding(.horizontal).padding(.top)
            .background(Rectangle().foregroundColor(.white))
            .clipShape(Rectangle())
            .shadow(color: Color("text.gray").opacity(0.5), radius: 20, x: 4, y: 12)
            .padding(.vertical).padding(.vertical).padding(.bottom)
              
            HStack(alignment: .center) {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
                
                Spacer()
                                
                Link(destination: URL(string: private_product_vm.get_product_by_id.link)!) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        Text("View product")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.blue)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.blue)
                    }.frame(width: UIScreen.main.bounds.width / 3)
                    
                }
                Spacer()
            }.padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(height: UIScreen.main.bounds.height * 0.6, alignment: .center)
        .onAppear {
            
            self.private_brand_vm.getBrandById(brand_id: brand_id)
            self.private_product_vm.getProductById(product_id: post.product_id)
            self.private_purchase_vm.getPurchaseById(purchase_id: post.purchase_id)
            
            let brandPath = "brand/" + brand_id + ".png"
            let productPath = "product/" + post.product_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(brandPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.brand_image_URL = "\(url!)"
                }
            }
            
            storage.child(productPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.product_image_URL = "\(url!)"
                }
            }
        }
    }
}

