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
    
    enum FocusField: Hashable {
      case field
    }

    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack {
//            HStack {
//                Text("Profile Photo")
//                    .font(Font.system(size: 40))
//                    .foregroundColor(.black)
//                    .bold()
//                Spacer()
//            }
//            if (profileViewModel.image != nil) {
//                Image(uiImage: profileViewModel.image!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
//                    .padding()
//                    .onTapGesture {
//                        profileViewModel.showSheet = true
//                    }
//            } else {
//                Image("portraitPlaceHolder")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
//                    .padding()
//                    .onTapGesture {
//                        profileViewModel.showSheet = true
//                    }
//            }
//            Button(action: {
//                profileViewModel.showSheet = true
//            }, label: {
//                Text("Update Profile Photo").font(.system(size: 14))
//            }).padding(.bottom, 16)
//
//            Spacer()
            
            Group {
                HStack {
                    Text("What do you want to be called?")
                        .font(Font.system(size: 40))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("You can change this later")
                        .font(Font.system(size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField("Your name", text: $profileViewModel.displayName)
                    .font(Font.system(size: 40))
                    .focused($focusedField, equals: .field)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                            self.focusedField = .field
                        }
                    }
            }.padding(.vertical, 4)
                    
            Spacer()
            
            let buttonOpacity = (profileViewModel.displayName.isEmpty) ? 0.5 : 1.0
            NavigationLink(destination: SetupStudentProfileView(profileViewModel: profileViewModel)) {
                HStack {
                    Text("Continue")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Color("LightGray"))
                .opacity(buttonOpacity)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 40)
                .padding(.top, 40)
            }.disabled(profileViewModel.displayName.isEmpty)
        }.padding(24)
        //      .navigationTitle("About You")
        .sheet(isPresented: $profileViewModel.showSheet) {
            PhotoGalleryPicker(pickerResult: $profileViewModel.image, isPresented: $profileViewModel.showSheet)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(authenticationViewModel: AuthenticationViewModel())
    }
}
