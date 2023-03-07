//
//  SelectBrand.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct SelectBrand: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Select Brand page")
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

struct SelectBrand_Previews: PreviewProvider {
    static var previews: some View {
        SelectBrand()
    }
}
