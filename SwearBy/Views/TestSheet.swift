//
//  TestSheet.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI

struct TestSheet: View {
    
    @Binding var selectedTab: Int
    
    
    var body: some View {
        
        VStack {
            Text("Hello, SLKDFJS!")
            
            Spacer()
            
            MyTabView(selectedTab: $selectedTab)
        }.edgesIgnoringSafeArea(.all)
    }
}


