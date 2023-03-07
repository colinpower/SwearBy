//
//  AddNewCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI



//enum AddNewCodeSheetPresented: String, Identifiable {
//    case add_brand, add_product
//    var id: String {
//        return self.rawValue
//    }
//}

struct AddNewCode: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var isPresentingChooseBrand:Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            addNewCodeHeader
            
            Spacer()
            Text("Add new code page...")
            Spacer()
            
            Button {
                isPresentingChooseBrand = true
            } label: {
                Text("show the next sheet")
            }
            
            
            Button {
                dismiss()
            } label: {
                Text("dismiss")
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
        .sheet(isPresented: $isPresentingChooseBrand) {
            SelectBrand()
        }
    }
    
    var addNewCodeHeader: some View {

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
            Text("Add New Code")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 40)
            Spacer()
            
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}
