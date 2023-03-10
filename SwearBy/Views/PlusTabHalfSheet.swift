//
//  ThrowawaySheet.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//

import SwiftUI

struct PlusTabHalfSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text("Add New")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
            }.padding(.top, 36).padding(.bottom)
            
            Divider()
            Button {
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fullScreenModalPresented = .add_post
                }
            } label: {
                PlusTabHalfSheetButton(icon_halfSheet: "checkmark.seal", title_halfSheet: "Swear By")                //person.badge.shield.checkmark
            }
            
            Button {
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fullScreenModalPresented = .add_code
                }
                
            } label: {
                PlusTabHalfSheetButton(icon_halfSheet: "questionmark.square.dashed", title_halfSheet: "Request")
            }
            
            Button {
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fullScreenModalPresented = .add_code
                }
            } label: {
                PlusTabHalfSheetButton(icon_halfSheet: "barcode", title_halfSheet: "Code")
            }
            
            Button {
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fullScreenModalPresented = .add_friends
                }
            } label: {
                PlusTabHalfSheetButton(icon_halfSheet: "person.2", title_halfSheet: "Friends")
            }
            
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct PlusTabHalfSheetButton: View {
    
    var icon_halfSheet: String
    var title_halfSheet: String
    
    var body: some View {
        
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
//                if icon_halfSheet == "" {
//                    ZStack(alignment: .center) {
//
//                        Image(systemName: "viewfinder")
//                            .font(.system(size: 26, weight: .regular, design: .rounded))
//                            .foregroundColor(Color("text.black"))
//
//                        Image(systemName: "bag.fill")
//                            .font(.system(size: 16, weight: .regular, design: .rounded))
//                            .foregroundColor(Color("text.black"))
//                            .padding(.bottom, 1)
//
//                    }.padding(.vertical, 17)
//                } else {
                    
                    Image(systemName: icon_halfSheet)
                        .font(.system(size: 26, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.vertical, 17)
//                }
                Spacer()
            }.frame(width: 36)
                .padding(.horizontal)
                .padding(.leading, 8)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(title_halfSheet)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top, 20)
                    .padding(.bottom, 21)
                Divider().foregroundColor(Color("text.gray"))
            }.frame(height: 60)
        }.frame(height: 60)
    }
}
