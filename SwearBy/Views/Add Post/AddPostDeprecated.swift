////
////  AddPost.swift
////  SwearBy
////
////  Created by Colin Power on 3/6/23.
////
//
////
////  AddPostDeprecated.swift
////  UncommonAppEasyReferrals
////
////  Created by Colin Power on 2/18/23.
////
//import SwiftUI
//
//struct AddPost: View {
//    @Environment(\.dismiss) var dismiss
//    
//    @ObservedObject var users_vm: UsersVM
////    @Binding var selectedTab: Int
////    @Binding var fullScreenModalPresented: FullScreenModalPresented?
//    
//    @State var isShowingAddPostSheet:Bool = false
//    
//    var body: some View {
//        
//        VStack {
//         
//            Spacer()
//            //MyTabView(selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
//            
//        }
//        .edgesIgnoringSafeArea(.all)
//        .background(Color("SwearByGold"))
//        .fullScreenCover(isPresented: $isShowingAddPostSheet) {
//            AddPostSheet(users_vm: users_vm, selectedTab: $selectedTab, isShowingAddPostSheet: $isShowingAddPostSheet)
//        }
//        .onAppear {
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                isShowingAddPostSheet = true
//            }
//        }
//        
//    }
//}
//
//
//
////MARK: ADD POST HEADER
//struct AddPostHeader: View {
//    
//    @ObservedObject var users_vm: UsersVM
//    
//    var title: String
//
//    
//    var body: some View {
//
//        HStack (alignment: .center) {
//            
//            Spacer()
//            Text(title)
//                .font(.system(size: 22, weight: .semibold, design: .rounded))
//                .foregroundColor(Color("text.black"))
//                .padding(.leading, 40)
//            Spacer()
//                        
//        }
//        .padding(.bottom, 4)
//        .frame(height: 44)
//        .padding(.top, 60)
//        .padding(.horizontal)
//        .padding(.horizontal, 4)
//    }
//}
//
//
//
