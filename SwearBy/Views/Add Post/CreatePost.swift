//
//  CreatePost.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

//import SwiftUI
//import PhotosUI
//import FirebaseStorage
//
//struct AddPost: View {
//    
//    @Environment(\.dismiss) var dismiss
//    
//    @ObservedObject var users_vm: UsersVM
////    @Binding var selectedTab: Int
////    @Binding var isShowingAddPostSheet: Bool
//    
//    /// - View Properties
//    @State private var showPicker: Bool = false
//    @State private var croppedImage: UIImage?
//    @State private var path = NavigationPath()
//    
//    
//    @State var description: String = ""
//    @State var product_link: String = ""
//    @State private var isPublic = false
//    
//    @State var switchedToPasteLink:Bool = false
//    
//    @FocusState private var descriptionFocused: Bool
//    @FocusState private var pasteLinkFocused: Bool
//    
//    var body: some View {
//        
//        VStack (spacing: 0) {
//            
//            NavigationStack(path: $path){
//                
//                VStack(spacing: 0) {
//                    
//                    //AddPostSheetHeader(users_vm: users_vm, croppedImage: $croppedImage, description: $description, product_link: $product_link, isPublic: $isPublic)
//                    addPostSheetHeader
//                    
//                    ScrollView(showsIndicators: false) {
//                        
//                        HStack(alignment: .top, spacing: 0) {
//                            
//                            let pic_width = UIScreen.main.bounds.width / 2 - 40
//                            
//                            Spacer()
//                            
//                            Button {
//                                showPicker.toggle()
//                            } label: {
//                                if let croppedImage{
//                                    Image(uiImage: croppedImage)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                        .frame(width: pic_width, height: pic_width)
//                                        .overlay(RoundedRectangle(cornerRadius: 20)
//                                            .stroke(lineWidth: 1)
//                                            .foregroundColor(.black))
//                                } else {
//                                    ZStack(alignment: .center) {
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .foregroundColor(Color("TextFieldGray"))
//                                            .frame(width: pic_width, height: pic_width)
//                                            .shadow(radius: 4)
//                                        
//                                        VStack(alignment: .center, spacing: 0) {
//                                            
//                                            Rectangle()
//                                                .foregroundColor(.clear)
//                                                .frame(width: 120, height: 32)
//                                            
//                                            Spacer()
//                                            
//                                            Text("Personal pic")
//                                                .font(.system(size: 12, weight: .regular, design: .rounded))
//                                                .foregroundColor(Color("text.gray"))
//                                            
//                                            Spacer()
//                                            Spacer()
//                                            
//                                            ZStack(alignment: .center) {
//                                                
//                                                Capsule()
//                                                    .foregroundColor(.blue)
//                                                    .frame(width: 120, height: 32)
//                                                Text("Tap to add")
//                                                    .font(.system(size: 15, weight: .medium, design: .rounded))
//                                                    .foregroundColor(Color.white)
//                                                
//                                                
//                                            }
//                                        }.padding(.horizontal).padding(.vertical)
//                                            .frame(width: pic_width, height: pic_width)
//                                    }
//                                }
//                            }
//                            
//                            Spacer()
//                            
//                            Button {
// 
//                                pasteLinkFocused = true
//                            } label: {
//                                
//                                ZStack(alignment: .center) {
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .foregroundColor(Color("TextFieldGray"))
//                                        .frame(width: pic_width, height: pic_width)
//                                        .shadow(radius: 4)
//                                    
//                                    VStack(alignment: .center, spacing: 0) {
//                                        
//                                        Rectangle()
//                                            .foregroundColor(.clear)
//                                            .frame(width: 120, height: 32)
//                                        
//                                        Spacer()
//                                        
//                                        Text("Product image")
//                                            .font(.system(size: 12, weight: .regular, design: .rounded))
//                                            .foregroundColor(Color("text.gray"))
//                                        
//                                        Spacer()
//                                        Spacer()
//                                        
//                                        
//                                        if (!description.isEmpty && product_link.isEmpty && !pasteLinkFocused) {
//                                            // blue
//                                            ZStack(alignment: .center) {
//                                                
//                                                Capsule()
//                                                    .foregroundColor(.blue)
//                                                    .frame(width: 120, height: 32)
//                                                Text("Paste link")
//                                                    .font(.system(size: 15, weight: .medium, design: .rounded))
//                                                    .foregroundColor(Color.white)
//                                                
//                                            }
//                                        } else {
//                                            ZStack(alignment: .center) {
//                                                
//                                                Capsule()
//                                                    .strokeBorder(lineWidth: 2).foregroundColor(Color.gray)
//                                                    .frame(width: 120, height: 32)
//                                                Text("Paste link")
//                                                    .font(.system(size: 15, weight: .medium, design: .rounded))
//                                                    .foregroundColor(Color.gray)
//                                                
//                                            }
//                                        }
//                                        
//                                    }.padding(.horizontal).padding(.vertical)
//                                        .frame(width: pic_width, height: pic_width)
//                                }
//                                
//                            }
//                            Spacer()
//                            
//                            
//                        }
//                        .padding(.vertical).padding(.vertical)
//                        
//                        TextField("Why do you swear by this item?", text: $description, axis: .vertical)
//                            .textFieldStyle(.plain)
//                            .font(.system(size: 15, weight: .regular))
//                            .focused($descriptionFocused)
//                            .submitLabel(.done)
//                            .onSubmit {
//                                descriptionFocused = false
//                                pasteLinkFocused = true
//                            }
//                            .padding(.leading)
//                            .frame(minHeight: 60, alignment: .topLeading)
//                            .padding(.horizontal)
//                        
//                        Divider()
//                            .padding(.vertical)
//                        
//                        VStack (alignment: .leading, spacing: 0) {
//                            
//                            HStack {
//                                Text("Paste link to product")
//                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                                    .padding(.bottom, 4)
//                                
//                                Spacer()
//                                
//                                
//                                // in-app webview
//                                // https://www.swiftanytime.com/blog/links-in-swiftui
//                                
//                                
//                            }
//                            
//                            Text("SwearBy will autofill details after you post")
//                                .font(.system(size: 15, weight: .regular, design: .rounded))
//                                .foregroundColor(.gray)
//                                .padding(.bottom)
//                            
//                            ZStack(alignment: .trailing) {
//                                TextField("https://www.apple.com/iphone-14/", text: $product_link)
//                                    .font(.system(size: 16, weight: .regular))
//                                    .foregroundColor(Color("text.black"))
//                                    .frame(height: 48)
//                                    .padding(.horizontal)
//                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("TextFieldGray")))
//                                    .submitLabel(.done)
//                                    .focused($pasteLinkFocused)
//                                    .keyboardType(.URL)
//                                    .disableAutocorrection(true)
//                             
//                                    
//                                    Link(destination: URL(string: "https://www.google.com")!) {
//                                        Text("Google")
//                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
//                                            .foregroundColor((pasteLinkFocused && product_link.isEmpty) ? Color.blue : Color.clear)
//                                            .padding(.vertical, 8)
//                                            .padding(.trailing)
//                                    }
//                                    
//                                
//                                
//                            }
//                            .padding(.bottom)
//                            
//                        }.padding(.horizontal)
//                        
//                        Divider()
//                            .padding(.vertical)
//                        
//                        VStack (alignment: .leading, spacing: 0) {
//                            
//                            Text(isPublic ? "Visibility: Everyone" : "Visibility: Friends Only")
//                                .font(.system(size: 18, weight: .semibold, design: .rounded))
//                                .padding(.bottom, 4)
//                            
//                            Toggle(isOn: $isPublic) {
//                                Text("Share with everyone on SwearBy")
//                                    .font(.system(size: 16, weight: .regular, design: .rounded))
//                                    .foregroundColor(.gray)
//                            }
//                            
//                        }.padding(.bottom)
//                            .padding(.horizontal)
//                        
//                        
//                        
//                        Spacer()
//                    }
//                    
//    //                NavigationLink(destination: PostDetails(users_vm: users_vm, croppedImage: $croppedImage, presentedSheet: $presentedSheet)) {
//    //                    Text("Go to next page")
//    //                }
//                    
////                    Image(systemName: "bag.badge.plus")
////
////                    Image(systemName: "bag.fill.badge.questionmark")
//                    
//                }
//                .onChange(of: croppedImage, perform: { newValue in
//                    //croppedimage
//                    descriptionFocused = true
//                })
//                .edgesIgnoringSafeArea(.all)
//                .background(Color("Background"))
//                .navigationTitle("")
//                .navigationBarTitleDisplayMode(.inline)
//                .cropImagePicker(
//                    options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
//                    show: $showPicker,
//                    croppedImage: $croppedImage
//                )
//            }
//        }
//    }
//    
//    var addPostSheetHeader: some View {
//
//        HStack (alignment: .center) {
//            
//            
//            Button {
//
//                dismiss()
//
//            } label: {
//
//                ZStack(alignment: .center) {
//                    Circle()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(Color("Background"))
//                    Image(systemName: "xmark")
//                        .font(.system(size: 24, weight: .semibold, design: .rounded))
//                        .foregroundColor(Color("text.black"))
//                }.padding(.trailing, 40)
//            }
//            
//            
//            Spacer()
//            Text("Create Post")
//                .font(.system(size: 22, weight: .semibold, design: .rounded))
//                .foregroundColor(Color("text.black"))
//            Spacer()
//            
//            if let croppedImage {
//                if ((description != "") && (product_link != "")) {
//                    
//                    Button {
//                        
//                        // Create ids
//                        let brand_id = UUID().uuidString
//                        let product_id = UUID().uuidString
//                        let purchase_id = UUID().uuidString
//                        let post_id = UUID().uuidString
//                        
//                        // Add brand
//                        BrandsVM().addBrand(brand_id: brand_id, name: "", website: product_link)
//                        
//                        // Add product
//                        ProductsVM().addProduct(brand_id: brand_id, link: product_link, name: "", product_id: product_id)
//                        
//                        // Add purchase
//                        PurchasesVM().addPurchase(brand_id: brand_id, product_id: product_id, purchase_id: purchase_id, user_id: users_vm.one_user.user_id, verification_status: "UNVERIFIED")
//                        
//                        // Add post
//                        PostsVM().addPost(description: description, is_public: isPublic, is_verified: false, post_id: post_id, product_id: product_id, purchase_id: purchase_id, timestamp: getTimestamp(), user_id: users_vm.one_user.user_id)
//                        
//                        // Add image
//                        uploadPhoto(post_id: post_id)
//                        
//                        
//                        dismiss()
//                        
//
//                    } label: {
//
//                        ZStack(alignment: .center) {
//                            
//                            Capsule()
//                                .foregroundColor(Color.blue)
//                                .frame(width: 80, height: 32)
//                            Text("Share")
//                                .font(.system(size: 16, weight: .semibold, design: .rounded))
//                                .foregroundColor(Color.white)
//                        }
//                    }
//                    
//                } else {
//                    ZStack(alignment: .center) {
//                        
//                        Capsule()
//                            .foregroundColor(Color("TextFieldGray"))
//                            .frame(width: 80, height: 32)
//                        Text("Share")
//                            .font(.system(size: 16, weight: .semibold, design: .rounded))
//                            .foregroundColor(Color.gray)
//                    }
//                }
//            } else {
//                
//                ZStack(alignment: .center) {
//                    
//                    Capsule()
//                        .foregroundColor(Color("TextFieldGray"))
//                        .frame(width: 80, height: 32)
//                    Text("Share")
//                        .font(.system(size: 16, weight: .semibold, design: .rounded))
//                        .foregroundColor(Color.gray)
//                }
//            }
//        }
//        .padding(.bottom, 4)
//        .frame(height: 44)
//        .padding(.top, 60)
//        .padding(.horizontal)
//        .padding(.horizontal, 4)
//    }
//    
//    
//    func uploadPhoto(post_id: String) {
//        
//        // Make sure that the selected image property isn't nil
//        guard croppedImage != nil else {
//            return
//        }
//        
//        // Create storage reference
//        let storageRef = Storage.storage().reference()
//        
//        // Turn our image into data
//        let imageData = croppedImage!.pngData()
//        
//        //let imageData = croppedImage!.jpegData(compressionQuality: 0.8)
//        
//        guard imageData != nil else {
//            print("returned nil.. trying to do it as a png instead")
//
//            return
//        }
//        
//        //Specify the file path and name
//        let fileRef = storageRef.child("post/\(post_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
//        
//        // Upload that data
//        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
//            
//            //Check for errors
//            if error == nil && metadata != nil {
//                
//                
//                print("successfully uploaded")
//                // TODO: Save a reference to the file in Firestore DB
//                
//                //PostViewModel().addPost(post_id: post_id, caption: caption, user_id: user_id)
//                
//            }
//        }
//        
//        
//        
//    }
//}
