////
////  OnboardingProfilePictureView.swift
////  FITs
////
////  Created by Andrew Pang on 7/7/22.
////
//
//import SwiftUI
//
//struct OnboardingProfilePictureView: View {
//    var body: some View {
////        VStack {
////            Group {
////                HStack {
////                    Text("What do you want to be called?")
////                        .font(Font.system(size: 40))
////                        .foregroundColor(.black)
////                        .bold()
////                    Spacer()
////                }
////                HStack {
////                    Text("You can change this later")
////                        .font(Font.system(size: 16))
////                        .foregroundColor(.gray)
////                    Spacer()
////                }
////                TextField("Your name", text: $profileViewModel.displayName)
////                    .font(Font.system(size: 40))
////                    .focused($focusedField, equals: .field)
////                    .onAppear {
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
////                            self.focusedField = .field
////                        }
////                    }
////            }.padding(.vertical, 4)
////
////            Spacer()
////
////            let buttonOpacity = (profileViewModel.displayName.isEmpty) ? 0.5 : 1.0
////            NavigationLink(destination: SetupStudentProfileView(profileViewModel: profileViewModel)) {
////                HStack {
////                    Text("Continue")
////                        .font(.system(size: 18))
////                        .foregroundColor(.black)
////                }
////                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
////                .background(Color("LightGray"))
////                .opacity(buttonOpacity)
////                .foregroundColor(.white)
////                .cornerRadius(8)
////                .padding(.horizontal, 40)
////                .padding(.top, 40)
////            }.disabled(profileViewModel.displayName.isEmpty)
////        }.padding(24)
////        //      .navigationTitle("About You")
////        .sheet(isPresented: $profileViewModel.showSheet) {
////            PhotoGalleryPicker(pickerResult: $profileViewModel.image, isPresented: $profileViewModel.showSheet)
////        }
//        }
//    }
//}
//
//struct OnboardingProfilePictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingProfilePictureView()
//    }
//}
