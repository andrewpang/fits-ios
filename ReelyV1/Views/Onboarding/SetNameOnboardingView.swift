//
//  EditProfileView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/28/22.
//

import SwiftUI
import struct Kingfisher.KFImage
import Amplitude

struct SetNameOnboardingView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    enum FocusField: Hashable {
      case field
    }

    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack() {
            Group {
                HStack {
                    Text("What should others call you?")
                        .font(Font.custom(Constants.titleFont, size: 40))
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("You can change this later")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField("Your name", text: $profileViewModel.displayName)
                    .font(Font.custom(Constants.titleFont, size: 32))
                    .focused($focusedField, equals: .field)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                            self.focusedField = .field
                        }
                    }
            }.padding(.vertical, 4)
                    
            Spacer()
            
            let buttonOpacity = (profileViewModel.displayName.isEmpty) ? 0.5 : 1.0
            NavigationLink(destination: ProfilePictureOnboardingView(profileViewModel: profileViewModel)) {
                HStack {
                    Text("Continue")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Constants.buttonColor)
                .opacity(buttonOpacity)
                .foregroundColor(.white)
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.bottom, Constants.onboardingButtonBottomPadding)
            }.disabled(profileViewModel.displayName.isEmpty)
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.padding(.horizontal, 24)
        .onAppear {
            Amplitude.instance().logEvent("Set Name Screen - View")
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameOnboardingView(authenticationViewModel: AuthenticationViewModel())
    }
}
