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
    
    var body: some View {
//        NavigationView {
            VStack {
                ScrollView {
                    if (profileViewModel.image != nil) {
                        Image(uiImage: profileViewModel.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                            .padding()
                            .onTapGesture {
                                profileViewModel.showSheet = true
                            }
                    } else {
                        Image("portraitPlaceHolder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                            .padding()
                            .onTapGesture {
                                profileViewModel.showSheet = true
                            }
                    }
                    
                    Button(action: {
                        profileViewModel.showSheet = true
                    }, label: {
                        Text("Update Profile Photo").font(.system(size: 14))
                    }).padding(.bottom, 16)
                    
                    Group {
                        HStack {
                            Text("What do you want to be called?")
                            Spacer()
                        }
                        TextField("Your name", text: $profileViewModel.displayName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.vertical, 4)
                    
//                    Group {
//                        HStack {
//                            Text("What's your graduation year?")
//                            Spacer()
//                        }
//                        Picker("", selection: $profileViewModel.graduationYear) {
//                            ForEach(2022...2026, id: \.self) {
//                                Text(String($0))
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }.padding(.vertical, 4)
//
//                    Group {
//                        HStack {
//                            Text("What's your major?")
//                            Spacer()
//                        }
//                        TextField("Your major", text: $profileViewModel.major)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }.padding(.vertical, 4)
//
//                    Group {
//                        HStack {
//                            Text("Describe yourself")
//                            Spacer()
//                        }
////                        HStack {
////                            Text("Tell us a bit about yourself, what you’re studying, what year you are, etc.").font(Font.system(size: 14)).foregroundColor(.gray)
////                            Spacer()
////                        }
//                    TextField("Your bio", text: $profileViewModel.bio)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                    TextEditor(text: $profileViewModel.bio)
////                                .overlay(RoundedRectangle(cornerRadius: 8)
////                                    .stroke(Color.gray).opacity(0.3))
////                                .frame(minHeight: 60)
//                    }.padding(.vertical, 4)
                }
                NavigationLink(destination: SetupStudentProfileView(profileViewModel: profileViewModel)) {
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
                }
            }.padding(24)
            .navigationTitle("About You")
            .sheet(isPresented: $profileViewModel.showSheet) {
                PhotoGalleryPicker(pickerResult: $profileViewModel.image, isPresented: $profileViewModel.showSheet)
            }
//        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(authenticationViewModel: AuthenticationViewModel())
    }
}
