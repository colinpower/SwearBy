//
//  AddNewBrand.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct AddNewBrand: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var private_brands_vm: BrandsVM
    
    @State private var name = ""
    
    @State private var website = ""
    
    @Binding var searchQuery:String
    
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationStack {
                VStack(spacing: 0) {
                    
                    addNewBrandHeader
                    
                    Form {
                        
                        Section {
                            TextField("Brand's name", text: $name)
                                .foregroundColor(Color("text.black"))
                                .multilineTextAlignment(.leading)
                                .keyboardType(.default)
                                .submitLabel(.done)
                        }
                        
                        Section {
                            TextField("Brand's website", text: $website)
                                .foregroundColor(Color("text.black"))
                                .multilineTextAlignment(.leading)
                                .keyboardType(.default)
                                .submitLabel(.done)
                            
                            Link(destination: URL(string: name != "" ? "https://www.google.com/search?q=" + name.replacingOccurrences(of: " ", with: "") : "https://www.google.com")!) {
                                Text(name != "" ? "Search Google for \(name)" : "Search Google")
                            }
                        }
                        
                    }.scrollContentBackground(.hidden)
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color("Background"))
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var addNewBrandHeader: some View {

        HStack (alignment: .center) {
            
            Button {

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
            Text("Add New Brand")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 40)
            Spacer()
            
            
            let canAddBrand = ((name != "") && (website != ""))
            
            Button {
                
                // create
                let brand_id = UUID().uuidString
                
                // upload the new code
                private_brands_vm.addBrand(brand_id: brand_id, name: name, website: website)
                
                // add the brand's name to the search query on prior page
                searchQuery = name
                
                //dismiss the sheet
                dismiss()
                
            } label: {
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(canAddBrand ? Color.blue : Color.gray)
                        .frame(width: 80, height: 32)
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                }
            }.disabled(!canAddBrand)
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}
