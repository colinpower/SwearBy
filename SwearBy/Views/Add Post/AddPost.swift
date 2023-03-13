//
//  AddPost.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//


import SwiftUI
import PhotosUI
import FirebaseStorage




struct AddPost: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var users_vm: UsersVM
//    @Binding var selectedTab: Int
//    @Binding var isShowingAddPostSheet: Bool
    
    /// - View Properties
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    @State private var path = NavigationPath()
    
    
    @State var description: String = ""
    @State var product_link: String = ""
    @State private var isPublic = false
    
    @State var switchedToPasteLink:Bool = false
    
    @FocusState private var descriptionFocused: Bool
    @FocusState private var pasteLinkFocused: Bool
    
    // Add Brand Picker
    @StateObject private var private_preloaded_referral_programs_vm = PreloadedReferralProgramVM()
    @State private var private_preloaded_referral_program = EmptyVariables().empty_preloaded_referral_program
    //@State private var isShowingBrandPicker:Bool = false
    // NOTE - use the preload to convert the brand info back into just the title and the website
    
    // Add Product Picker
    // TO DO...
    @State private var selected_product:Products = EmptyVariables().empty_products
    @State private var isShowingProductPicker:Bool = false
    
    // Enum to filter between brands and products modals
    @State private var addNewPostFullScreenPresented: AddNewPostFullScreenPresented?
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            NavigationStack(path: $path){
                
                VStack(spacing: 0) {
                    
                    //AddPostSheetHeader(users_vm: users_vm, croppedImage: $croppedImage, description: $description, product_link: $product_link, isPublic: $isPublic)
                    addPostSheetHeader
                    
                    ScrollView(showsIndicators: false) {
                        
                        HStack(alignment: .top, spacing: 0) {
                            
                            let pic_width = UIScreen.main.bounds.width * 0.6
                            
                            Spacer()
                            
                            Button {
                                showPicker.toggle()
                            } label: {
                                if let croppedImage{
                                    Image(uiImage: croppedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .frame(width: pic_width, height: pic_width)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(.black))
                                } else {
                                    ZStack(alignment: .center) {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundColor(Color("TextFieldGray"))
                                            .frame(width: pic_width, height: pic_width)
                                            .shadow(radius: 4)
                                        
                                        VStack(alignment: .center, spacing: 0) {
                                            
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 120, height: 32)
                                            
                                            Spacer()
                                            
                                            Text("Personal pic")
                                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                                .foregroundColor(Color("text.gray"))
                                            
                                            Spacer()
                                            Spacer()
                                            
                                            ZStack(alignment: .center) {
                                                
                                                Capsule()
                                                    .foregroundColor(.blue)
                                                    .frame(width: 120, height: 32)
                                                Text("Tap to add")
                                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                                    .foregroundColor(Color.white)
                                                
                                                
                                            }
                                        }.padding(.horizontal).padding(.vertical)
                                            .frame(width: pic_width, height: pic_width)
                                    }
                                }
                            }
                            
                            Spacer()
                            
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
                            
                            
                        }
                        .padding(.vertical).padding(.vertical)
                        
                        TextField("Why do you swear by this item?", text: $description, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(.system(size: 15, weight: .regular))
                            .focused($descriptionFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                descriptionFocused = false
                                //pasteLinkFocused = true
                            }
                            .padding(.leading)
                            .frame(minHeight: 60, alignment: .topLeading)
                            .padding(.horizontal)
                        
                        Divider()
                            .padding(.top)
                        
                        if private_preloaded_referral_program.brand_id == "" {
                            Button {
                                addNewPostFullScreenPresented = .add_brand
                            } label: {
                                AddPost_BrandButton(icon_halfSheet: "heart", referral_program: $private_preloaded_referral_program)
                            }
                        } else {
                            AddPost_BrandButton(icon_halfSheet: "heart", referral_program: $private_preloaded_referral_program)
                        }
                        
                        if private_preloaded_referral_program.brand_id != "" {
                            if selected_product.product_id == "" {
                                Button {
                                    addNewPostFullScreenPresented = .add_product
                                } label: {
                                    AddPost_ProductButton(icon_halfSheet: "bag", chosen_product: $selected_product)
                                }
                            } else {
                                AddPost_ProductButton(icon_halfSheet: "bag", chosen_product: $selected_product)
                            }
                        }
                        
//                        AddPost_BrandOrProductButton(icon_halfSheet: "bag", title_halfSheet: "Select a product")
//
//                        AddPost_BrandOrProductButton(icon_halfSheet: "barcode", title_halfSheet: "Add referral code")

//
//                        // UNDO THIS ONCE IVE CREATED AN ENUM TO HANDLE THIS INSTEAD
//                        if private_preloaded_referral_program.brand_id == "" {
//                            Button {
//                                addNewPostFullScreenPresented = .add_brand
////                                isShowingBrandPicker = true
//                            } label: {
//                                HStack {
//                                    Text("Select a brand")
//                                    Spacer()
//                                }
//                                .padding()
//                            }
//
//                        } else {
//
//                            HStack {
//                                Text(private_preloaded_referral_program.brand_name)
//                                Spacer()
//                                Button {
//                                    private_preloaded_referral_program = EmptyVariables().empty_preloaded_referral_program
//                                } label: {
//                                    Image(systemName: "xmark")
//                                }
//                            }
//                            .padding()
//
//                        }
                        
                        
                        //DFDC5036-081B-4E0E-80A5-6020C00D7A95

//                        let brand_id_temp_var = "DFDC5036-081B-4E0E-80A5-6020C00D7A95"
//
//                        if private_preloaded_referral_program.brand_id == "" {
////                        if brand_id_temp_var == "" {
//
//                        } else {
//                            if selected_product.product_id == "" {
//                                Button {
//                                    addNewPostFullScreenPresented = .add_product
////                                    isShowingProductPicker = true
//                                } label: {
//                                    HStack {
//                                        Text("Select a product")
//                                        Spacer()
//                                    }
//                                    .padding()
//                                }
//
//                            } else {
//
//                                HStack {
//                                    Text(selected_product.name)
//                                    Spacer()
//                                    Button {
//                                        selected_product = EmptyVariables().empty_products
//                                    } label: {
//                                        Image(systemName: "xmark")
//                                    }
//                                }
//                                .padding()
//
//                            }
//                        }

                        
                        
                        // POTENTIALLY KEEP THIS SECTION
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
                        
                        
                        
                        Spacer()
                    }
                }
                .onChange(of: croppedImage, perform: { newValue in
                    //croppedimage
                    descriptionFocused = true
                })
                .edgesIgnoringSafeArea(.all)
                .background(Color("Background"))
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .cropImagePicker(
                    options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
                    show: $showPicker,
                    croppedImage: $croppedImage
                )
                .fullScreenCover(item: $addNewPostFullScreenPresented, onDismiss: { addNewPostFullScreenPresented = nil }) { sheet in
                    
                    switch sheet {        //add_friends, add_code, add_preloaded_code
                    case .add_brand:
                        SelectBrand(preloaded_referral_programs_vm: private_preloaded_referral_programs_vm, preloaded_referral_program: $private_preloaded_referral_program)
                    case .add_product:
                        SelectProduct(brand_id_filtered: private_preloaded_referral_program.brand_id, selected_product: $selected_product)
                    }
                }
                
            }
        }
    }
    
    var addPostSheetHeader: some View {

        HStack (alignment: .center) {
            
            
            Button {

                dismiss()

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Background"))
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }.padding(.trailing, 40)
            }
            
            
            Spacer()
            Text("Create Post")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            Spacer()
            
            if let croppedImage {
                if ((description != "") && (product_link != "")) {
                    
                    Button {
                        
                        // Create ids
                        let brand_id = UUID().uuidString
                        let product_id = UUID().uuidString
                        let purchase_id = UUID().uuidString
                        let post_id = UUID().uuidString
                        
                        // Add brand
                        BrandsVM().addBrand(brand_id: brand_id, name: "", website: product_link)
                        
                        // Add product
                        ProductsVM().addProduct(brand_id: brand_id, link: product_link, name: "", product_id: product_id)
                        
                        // Add purchase
                        PurchasesVM().addPurchase(brand_id: brand_id, product_id: product_id, purchase_id: purchase_id, user_id: users_vm.one_user.user_id, verification_status: "UNVERIFIED")
                        
                        // Add post
                        PostsVM().addPost(description: description, is_public: isPublic, is_verified: false, post_id: post_id, product_id: product_id, purchase_id: purchase_id, timestamp: getTimestamp(), user_id: users_vm.one_user.user_id)
                        
                        // Add image
                        uploadPhoto(post_id: post_id)
                        
                        
                        dismiss()
                        

                    } label: {

                        ZStack(alignment: .center) {
                            
                            Capsule()
                                .foregroundColor(Color.blue)
                                .frame(width: 80, height: 32)
                            Text("Share")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                        }
                    }
                    
                } else {
                    ZStack(alignment: .center) {
                        
                        Capsule()
                            .foregroundColor(Color("TextFieldGray"))
                            .frame(width: 80, height: 32)
                        Text("Share")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.gray)
                    }
                }
            } else {
                
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(Color("TextFieldGray"))
                        .frame(width: 80, height: 32)
                    Text("Share")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
    
    
    func uploadPhoto(post_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard croppedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = croppedImage!.pngData()
        
        //let imageData = croppedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        let fileRef = storageRef.child("post/\(post_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                
                //PostViewModel().addPost(post_id: post_id, caption: caption, user_id: user_id)
                
            }
        }
        
        
        
    }
}


struct AddPost_BrandButton: View {
    
    var icon_halfSheet: String
    @Binding var referral_program: PreloadedReferralPrograms
    
    
    var body: some View {
        
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: icon_halfSheet)
                    .font(.system(size: 26, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.vertical, 17)
                Spacer()
            }.frame(width: 36)
                .padding(.horizontal)
                .padding(.leading, 8)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(referral_program.brand_name == "" ? "Add brand" : referral_program.brand_name)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    Spacer()
                    
                    if referral_program.brand_name == "" {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                    } else {
                        Button {
                            referral_program = EmptyVariables().empty_preloaded_referral_program
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("text.gray"))
                        }
                    }
                }
                .padding(.trailing)
                .padding(.top, 20)
                .padding(.bottom, 21)
                Divider().foregroundColor(Color("text.gray"))
            }.frame(height: 60)
        }.frame(height: 60)
    }
}




struct AddPost_ProductButton: View {
    
    var icon_halfSheet: String
    @Binding var chosen_product: Products
    
    
    var body: some View {
        
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: icon_halfSheet)
                    .font(.system(size: 26, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.vertical, 17)
                Spacer()
            }.frame(width: 36)
                .padding(.horizontal)
                .padding(.leading, 8)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(chosen_product.name == "" ? "Select product" : chosen_product.name)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    Spacer()
                    
                    if chosen_product.name == "" {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                    } else {
                        Button {
                            chosen_product = EmptyVariables().empty_products
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("text.gray"))
                        }
                    }
                    
                }.padding(.trailing)
                .padding(.top, 20)
                .padding(.bottom, 21)
                Divider().foregroundColor(Color("text.gray"))
            }.frame(height: 60)
        }.frame(height: 60)
    }
}
