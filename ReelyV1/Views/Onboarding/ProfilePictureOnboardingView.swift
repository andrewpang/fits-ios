//
//  OnboardingProfilePictureView.swift
//  FITs
//
//  Created by Andrew Pang on 7/7/22.
//

import SwiftUI
import Amplitude

struct ProfilePictureOnboardingView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var navigateToNextView = false
    
    var body: some View {
        VStack() {
            Group {
                HStack {
                    Text("Would you like to upload a profile photo?")
                        .font(Font.custom(Constants.titleFont, size: 40))
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("You can also add a photo later")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }.padding(.vertical, 4)
            
            if (profileViewModel.image != nil) {
                  Image(uiImage: profileViewModel.image!)
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                      .clipShape(Circle())
                      .overlay(Circle().stroke(Constants.buttonColor, lineWidth: 3))
                      .padding()
                      .onTapGesture {
                          profileViewModel.showPhotoSelectorSheet = true
                      }
              } else {
                  Image("portraitPlaceHolder")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                      .clipShape(Circle())
                      .overlay(Circle().stroke(Constants.buttonColor, lineWidth: 3))
                      .padding()
                      .onTapGesture {
                          profileViewModel.showPhotoSelectorSheet = true
                      }
              }
              Button(action: {
                  profileViewModel.showPhotoSelectorSheet = true
              }, label: {
                  Text("Update Profile Photo")
                      .font(Font.custom(Constants.buttonFont, size: 16))
              }).padding(.bottom, 16)
                    
            Spacer()
            
            NavigationLink(destination: SignUpControllerWrapper(profileViewModel: profileViewModel), isActive: $navigateToNextView) {
                HStack {
                    Text("Continue")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Constants.buttonColor)
                .foregroundColor(.white)
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.bottom, Constants.onboardingButtonBottomPadding)
            }
        }.padding(.horizontal, 24)
        .sheet(isPresented: $profileViewModel.showPhotoSelectorSheet) {
            PhotoGalleryPicker(pickerResult: $profileViewModel.image, isPresented: $profileViewModel.showPhotoSelectorSheet)
        }.toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Skip for now") {
                    profileViewModel.image = nil
                    self.navigateToNextView = true
                }
            }
        }
        .onAppear {
            Amplitude.instance().logEvent("Set Profile Picture Screen - View")
        }
    }
}

//struct OnboardingProfilePictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingProfilePictureView()
//    }
//}
