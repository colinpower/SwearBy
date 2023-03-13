//
//  SelectProduct.swift
//  SwearBy
//
//  Created by Colin Power on 3/10/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct SelectProduct: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var brand_id_filtered:String = ""
    
    @StateObject private var private_products_vm = ProductsVM()
    @Binding var selected_product: Products
    
    @State private var searchQuery = ""
//    @State private var filteredProducts:[Products] = []
    @State private var isShowingAddProductSheet:Bool = false
    
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            //selectBrandHeader
            
            NavigationStack {
                    
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 0) {
    
                        
                        ForEach(searchQuery == "" ? private_products_vm.products_for_brand : private_products_vm.products_for_brand.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }) { temp_product in
                            
                            Button {
                                
                                selected_product = Products(name: temp_product.name, link: temp_product.link, brand_id: temp_product.brand_id, product_id: temp_product.product_id)
                                
                                // Dismiss
                                dismiss()
                                
                            } label: {
                                
                                ProductRow(product: temp_product)
                                
                            }
                        }
                        
                        Button {
                            isShowingAddProductSheet = true
                        } label: {
                            AddProductRow()
                        }
                        
                    }
                    .searchable(text: $searchQuery, prompt: "Search by product or add new")
                    .padding(.bottom, 100)
                    .padding(.horizontal)
                    .navigationTitle("Select Brand")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("text.black"))
                            }
                        }
                    }
                }
                

            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))

//        .onSubmit(of: .search, {
//            filterBrands()
//            })
        .onAppear {
            
            if brand_id_filtered == "" {
                
            } else {
                self.private_products_vm.listenForProductsForBrand(brand_id: brand_id_filtered)
                
            }
            
//            filteredProducts = private_products_vm.listenForProductsForBrand(brand_id: brand_id_filtered)

        }
        .sheet(isPresented: $isShowingAddProductSheet) {
            AddNewProduct(brand_id: $brand_id_filtered, searchQuery: $searchQuery)
            //AddNewBrand(private_brands_vm: private_brands_vm, searchQuery: $searchQuery)
        }
    }
    
    
    var selectBrandHeader: some View {

        HStack (alignment: .center) {
            
            
            Button {

                //isPreloadedCode = true
                dismiss()

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Background"))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
            }
            
            Spacer()
            
            Button {
                
                // load the "Add Brand" sheet
                isShowingAddProductSheet = true
                
            } label: {
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(Color.blue)
                        .frame(width: 120, height: 32)
                    Text("Create New")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                }
            }
            
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
    
}










struct ProductRow: View {

    var product:Products
    
    @State private var private_productURL = ""

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            if private_productURL != "" {
                WebImage(url: URL(string: private_productURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    if product.name.count > 0 {
                        Text(product.name.prefix(1))
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    } else {
                        Text("?")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            

            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {

                Text(product.name != "" ? product.name : "?")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.vertical, 6)
//                Text(formattedBrandWebsite(website: brand.website))
//                    .foregroundColor(Color("text.gray"))
//                    .font(.system(size: 16, weight: .regular))
//                    .lineLimit(1)
            }.padding(.leading, 16)

            Spacer()

            ZStack(alignment: .center) {
                Capsule().frame(width: 90, height: 36)
                    .foregroundColor(.green)
                Text("Select")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
            }

        }
        .padding(.vertical, 12)
        .onAppear {

            let backgroundPath = "product/" + product.product_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_productURL = "\(url!)"
                }
            }
        }
    }
    
//    func formattedProductWebsite(website: String) -> String {
//
//        var parsed = website.replacingOccurrences(of: "https://", with: "")
//
//        parsed = website.replacingOccurrences(of: "http://", with: "")
//
//        parsed = website.replacingOccurrences(of: "www.", with: "")
//
//        if parsed.last == "/" {
//            parsed = String(parsed.prefix(parsed.count-1))
//        }
//
//        return parsed.lowercased()
//    }
    
    
}

struct AddProductRow: View {

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            ZStack(alignment: .center) {
                Circle().frame(width: 40, height: 40)
                    .foregroundColor(Color("SwearByGold"))
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
            }
            
            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {

                Text("New product")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                Text("Tap to add")
                    .foregroundColor(Color("text.gray"))
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(1)
            }.padding(.leading, 16)

            Spacer()

            ZStack(alignment: .center) {
                Capsule().frame(width: 90, height: 36)
                    .foregroundColor(Color("SwearByGold"))
                Text(" Add ")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
            }

        }
        .padding(.vertical, 12)
    }
}

