//
//  SelectBrand.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct SelectBrand: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected_brand:Brands
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Select Brand page")
            Spacer()
            
            VStack {
                Text("THE SELECTED BRAND IS...")
                Text(selected_brand.name)
            }
            
            Spacer()
            
            Button {
                selected_brand = Brands(name: "lsdakfj", website: "asldkfas", brand_id: "asldkfaj")
            } label: {
                
                Text("select this brand")
                
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("dismiss")
            }
            
            Spacer()
        }
        
        
    }
}
