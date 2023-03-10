//
//  SelectBrand.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct SelectBrand: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var preloaded_referral_programs_vm: PreloadedReferralProgramVM
    @Binding var preloaded_referral_program: PreloadedReferralPrograms
    
    @StateObject private var private_brands_vm = BrandsVM()
    
    @State var searchQuery = ""
    @State var filteredBrands:[Brands] = []
    @State var isShowingAddBrandSheet:Bool = false
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            //selectBrandHeader
            
            NavigationStack {
                    
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 0) {
    
                        
                        ForEach(searchQuery == "" ? private_brands_vm.all_brands : private_brands_vm.all_brands.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }) { brand in
                            
                            Button {
                                
                                let temp_preload:[PreloadedReferralPrograms] = preloaded_referral_programs_vm.preloaded_referral_programs.filter { $0.brand_id == brand.brand_id }
                                
                                // If this brand isn't one of the preloaded ones
                                if temp_preload.isEmpty {
                                    
                                    preloaded_referral_program = EmptyVariables().empty_preloaded_referral_program
                                    preloaded_referral_program.brand_name = brand.name
                                    preloaded_referral_program.brand_id = brand.brand_id
                                
                                    // Else if it is one of the preloaded ones
                                } else {
                                    preloaded_referral_program = temp_preload.first ?? PreloadedReferralPrograms(brand_id: brand.brand_id, brand_name: brand.name, code: "", commission_type: "None", commission_value: "", expiration: 0, for_new_customers_only: false, minimum_spend: "", link: "", link_for_setup: "", offer_type: "", offer_value: "", preloaded_referral_program_id: "", product_ids: [], steps: SetupReferralSteps(one: "", two: "", three: ""))
                                }
                                
                                // Dismiss
                                dismiss()
                                
                            } label: {
                                
                                BrandRow(brand: brand)
                                
                            }
                        }
                    }
                    .searchable(text: $searchQuery, prompt: "Search by brand name")
                    .padding(.bottom, 100)
                    .padding(.horizontal)
                    .navigationTitle("Select Brand")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            //this is a hack to get a navigationlink inside a toolbarItem
                            Button {
                                isShowingAddBrandSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.blue)
                            }
                                
                            
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            Button {
                                
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.down")
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

            self.private_brands_vm.listenForAllBrands()
            
            filteredBrands = private_brands_vm.all_brands

        }
        .onDisappear {
            
            if self.private_brands_vm.all_brands_listener != nil {
                self.private_brands_vm.all_brands_listener.remove()
            }
            
        }
        .sheet(isPresented: $isShowingAddBrandSheet) {
            AddNewBrand(private_brands_vm: private_brands_vm, searchQuery: $searchQuery)
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
                isShowingAddBrandSheet = true
                
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










struct BrandRow: View {

    var brand:Brands
    
    @State private var private_brandURL = ""

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            if private_brandURL != "" {
                WebImage(url: URL(string: private_brandURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    if brand.name.count > 0 {
                        Text(brand.name.prefix(1))
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

                Text(brand.name != "" ? brand.name : "?")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                Text(formattedBrandWebsite(website: brand.website))
                    .foregroundColor(Color("text.gray"))
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(1)
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

            let backgroundPath = "brand/" + brand.brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_brandURL = "\(url!)"
                }
            }
        }
    }
    
    func formattedBrandWebsite(website: String) -> String {
        
        var parsed = website.replacingOccurrences(of: "https://", with: "")
        
        parsed = website.replacingOccurrences(of: "http://", with: "")
        
        parsed = website.replacingOccurrences(of: "www.", with: "")
        
        if parsed.last == "/" {
            parsed = String(parsed.prefix(parsed.count-1))
        }
        
        return parsed.lowercased()
    }
    
    
}


struct AddBrandRow: View {

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            ZStack(alignment: .center) {
                Circle().frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
            }
            

            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer()
                Text("Add a new brand")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding(.bottom, 6)
                Spacer()
                
            }.padding(.leading, 16)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.gray"))

        }
        .padding(.vertical, 12)
    }
}

