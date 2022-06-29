//
//  EditProfileView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/28/22.
//

import SwiftUI
import struct Kingfisher.KFImage

struct EditProfileView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @State var image: UIImage = UIImage()
    
    var body: some View {
        NavigationView {
            VStack {
                KFImage(URL(string: profileViewModel.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .padding()
                    .onTapGesture {
                        profileViewModel.showSheet = true
                    }
                Button(action: {
                    profileViewModel.showSheet = true
                }, label: {
                    Text("Update Profile Photo")
                })
                
                Spacer()
                Group {
                    HStack {
                        Text("What should others call you?").bold()
                        Spacer()
                    }
                    TextField("Your name", text: $profileViewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
            
                    HStack {
                        Text("Describe yourself").bold()
                        Spacer()
                    }
                    HStack {
                        Text("Tell us a bit about yourself, what you’re studying, what year you are, etc.").font(Font.system(size: 14)).foregroundColor(.gray)
                        Spacer()
                    }
                    TextField("Your bio", text: $profileViewModel.bio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextEditor(text: $bio)
//                            .overlay(RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray).opacity(0.3))
//                            .frame(minHeight: 60)
                }
                
                Spacer()
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                        Text("Confirm")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }.padding(.top, 40)
//                .disabled(self.homeViewModel.isLoading)
            }.onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }.padding(24)
            .navigationTitle("Profile")
            .sheet(isPresented: $profileViewModel.showSheet) {
                PhotoGalleryPicker(pickerResult: $image, isPresented: $profileViewModel.showSheet)
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(authenticationViewModel: AuthenticationViewModel())
    }
}
