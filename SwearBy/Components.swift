//
//  Components.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//
import SwiftUI
import Foundation
import SDWebImageSwiftUI
import FirebaseStorage


//MARK: TABVIEW
struct MyTabView: View {
    
    @Binding var selectedTab:Int
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().frame(height: 0.5).padding(.bottom, 10)
            HStack(alignment: .bottom) {
                Spacer()
                TabViewItem(position: 0, selectedTab: $selectedTab)
                TabViewItem(position: 1, selectedTab: $selectedTab)
                TabViewItem(position: 2, selectedTab: $selectedTab)
                Spacer()
            }.padding(.horizontal)
            Spacer()
        }.edgesIgnoringSafeArea(.bottom)
        .frame(height: 80)
        .background(Color("Background"))
    }
}


//MARK: TABVIEW
struct TabViewItem: View {
    
    var position: Int
    @Binding var selectedTab:Int
    
    var tabViewItemImageName: [String] {
        switch position {
        case 0:
            return ["house.fill", "Home"]
        case 1:
            return ["plus.square.fill", "Add Post"]
        case 2:
            return ["person.fill", "Profile"]
        default:
            return ["house.fill", "Home"]
        }
    }
    
    var body: some View {

            Button {
                selectedTab = position
            } label: {
                VStack (alignment: .center) {
                    
                    Image(systemName: tabViewItemImageName[0])
                        .foregroundColor(selectedTab == position ? Color("text.black") : Color("text.gray"))
                        .font(.system(size: 25, weight: .regular))
                    Spacer()
                    Text(tabViewItemImageName[1])
                        .foregroundColor(selectedTab == position ? Color("text.black") : Color("text.gray"))
                        .font(.system(size: 10, weight: .medium))
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: 36)
    }
}


extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

//MARK: PRIMARY HEADER
struct PrimaryHeader: View {
    
    var title: String
    @Binding var isShowingAddFriendsPage: Bool
    
    var body: some View {

        HStack (alignment: .center) {
            
            Spacer()
            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 40)
            Spacer()
            
            Button {

                isShowingAddFriendsPage = true

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("ShareGray"))
                    Image(systemName: "person.fill.badge.plus")
                        .font(.system(size: 19))
                        .foregroundColor(Color("text.gray"))
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


