//
//  Profile.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct Profile: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @ObservedObject var users_vm: UsersVM
    
    @StateObject var posts_vm:PostsVM = PostsVM()
    
    @Binding var email: String
    @Binding var selectedTab: Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    @State private var path = NavigationPath()
    
    @State private var private_profileImageURL:String = ""
    
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    let columns: [GridItem] = [
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 32), spacing: 16, alignment: nil),
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 32), spacing: 16, alignment: nil)
            ]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            NavigationStack(path: $path) {
                VStack(spacing: 0) {
                    
                    PrimaryHeader(users_vm: users_vm, title: "My Profile", fullScreenModalPresented: $fullScreenModalPresented)
                    
                    myProfileTopSection
                        .padding(.vertical)
                    
                    myProfileButtons
                        .padding(.vertical)
                        .padding(.bottom)
                    
                    ScrollView(showsIndicators: false) {
                    
                        VStack (alignment: .center, spacing: 0) {
                            
                            HStack (spacing: 0) {
                                Text("My Posts")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(Color("text.black"))
                                    .padding(.bottom, 4)
                                Spacer()
                            }
                            .padding(.bottom)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                
                                ForEach(posts_vm.my_posts) { post in
                                    
                                    Button {
                                        
                                        path.append(post)
                                        
                                    } label: {
                                        ProfilePostWidget(post: post)
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                                        .stroke(lineWidth: 1)
                                                                        .foregroundColor(Color("TextFieldGray")))
                                    }
                                }
                            }.padding(.bottom, 100)
                        }
                        
                    }.padding(.horizontal)
                }
                .onChange(of: croppedImage, perform: { newValue in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        uploadPhoto(user_id: users_vm.one_user.user_id)
                    }
                    
                })
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Posts.self) { post in
                    PostView(users_vm: users_vm, post: post, path: $path)
                }
                .navigationDestination(for: Users.self) { user in
                    FriendProfile(users_vm: users_vm, path: $path, friend_user: user)
                }
                .cropImagePicker(
                    options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
                    show: $showPicker,
                    croppedImage: $croppedImage
                )
                
            }
            MyTabView(users_vm: users_vm, selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(item: $fullScreenModalPresented, onDismiss: { fullScreenModalPresented = nil }) { sheet in
    
            switch sheet {        //add_friends, add_code, add_preloaded_code
            case .add_friends:
                AddFriends(users_vm: users_vm)
            case .add_post:
                AddPost(users_vm: users_vm)
            case .settings:
                Settings(users_vm: users_vm, email: $email, selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
            default:
                AddFriends(users_vm: users_vm)
            }
        }
        .onAppear {
            
            self.posts_vm.listenForMyPosts(users_vm: users_vm)
            
            let storage = Storage.storage().reference()
            
            let userPath = "user/" + users_vm.one_user.user_id + ".png"
            
            storage.child(userPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_profileImageURL = "\(url!)"
                }
            }
        }
    }
    
    func uploadPhoto(user_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard croppedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = croppedImage!.pngData()
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        let fileRef = storageRef.child("user/\(user_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                // make call to Firebase here...
                
            }
        }
    }
    
    
    var myProfileTopSection: some View {
        
        // Image, Name, Num of friends
        HStack(alignment: .top, spacing: 0) {
            
            Button {
                showPicker.toggle()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    if let croppedImage {
                        
                        Image(uiImage: croppedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            
                    } else {
                        
                        if private_profileImageURL != "" {
                            WebImage(url: URL(string: private_profileImageURL)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        }
                    }
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        Image(systemName: "camera.circle.fill")
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                    }
                }
            }
                    
            VStack(alignment: .leading, spacing: 0) {
                    
                    Text(users_vm.one_user.name.first_last)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 0) {
                        
                        let num_friends = users_vm.one_user.friends_list.count
                        let num_posts = posts_vm.my_posts.count
                        
                        Text(String(num_friends))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                        
                        Text(num_friends == 1 ? " Friend" : " Friends")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color("text.black"))
                            .padding(.trailing)
                        
                        Text(String(num_posts))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                        
                        Text(num_posts == 1 ? " Post" : " Posts")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color("text.black"))
                        
                        Spacer()
                        
                    }
                    
                    
                }.padding(.leading).padding(.leading).padding(.vertical)
            
        }.padding(.horizontal)
    }
    
    var myProfileButtons: some View {
            
        // Settings, Share Profile
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                fullScreenModalPresented = .settings
            } label: {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    
                    Spacer()
                }
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("TextFieldGray")))
            }
            .padding(.horizontal)
            
            ShareLink(item: "Hey, join me on SwearBy app! <insert URL here>", preview: SharePreview(
                "Join me on SwearBy!",
                image: Image("AppIcon"))) {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Text(" Share ")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.green))
                    
                }.padding(.horizontal)
            
        }
    }
}

struct ProfilePostWidget: View {
    
    var post: Posts
    
    @State private var private_profile_postURL: String = ""
    
    var body: some View {
        
        Group {
            if private_profile_postURL != "" {
                WebImage(url: URL(string: private_profile_postURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: UIScreen.main.bounds.width / 2 - 32, height: UIScreen.main.bounds.width / 2 - 32)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width / 2 - 32, height: UIScreen.main.bounds.width / 2 - 32)
                
            }
        }
        .onAppear {
            
            let backgroundPath = "post/" + post.post_id + ".png"
            
            let storage = Storage.storage().reference()
            
            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_profile_postURL = "\(url!)"
                }
            }
        }
    }
}






//MARK: Sign Out button
//            Button {
//
//                let signOutResult = viewModel.signOut(users_vm: users_vm)
//
//                email = ""
//
//                selectedTab = 0
//
//                if !signOutResult {
//                    //error signing out here.. handle it somehow?
//                }
//
//            } label: {
//
//                HStack(alignment: .center) {
//                    Spacer()
//                    Text("Sign Out")
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .foregroundColor(Color("UncommonRed"))
//                    Spacer()
//                }
//                .frame(height: 50)
//                //.background(Capsule().foregroundColor(Color("UncommonRed")))
//                .padding(.horizontal)
//            }
