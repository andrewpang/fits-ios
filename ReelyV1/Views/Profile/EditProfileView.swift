//
//  SetupStudentProfileView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/29/22.
//

import SwiftUI
import Amplitude

struct EditProfileView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var displayNameTextField = ""
    @State var graduationYearPicker = -1
    @State var majorTextField = ""
    @State var bioTextField = ""
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                HStack {
                    Text("What do you want to be called?")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                TextField("Your name", text: $displayNameTextField)
                    .font(Font.custom(Constants.bodyFont, size: 18))
                Divider()
            }
            
            Group {
                HStack {
                    Text("What's your major?")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                TextField("Your major", text: $majorTextField)
                    .font(Font.custom(Constants.bodyFont, size: 18))
                Divider()
            }
            
            Group {
                HStack {
                    Text("What class are you?")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                Picker("", selection: $graduationYearPicker) {
                    ForEach(2023...2026, id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Group {
                HStack {
                    Text("Describe yourself")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                TextField("Your bio", text: $bioTextField)
                    .font(Font.custom(Constants.bodyFont, size: 18))
//                    TextEditor(text: $bio)
//                            .overlay(RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray).opacity(0.3))
//                            .frame(minHeight: 60)
                Divider()
            }

            Spacer()
            
            Button(action: {
                authenticationViewModel.updateUserModel(displayName: displayNameTextField, major: majorTextField, graduationYear: graduationYearPicker, bio: bioTextField)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Text("Update Profile")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(.blue)
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.vertical, 24)
            })
        }.padding(24)
            .onAppear {
                self.displayNameTextField = authenticationViewModel.userModel?.displayName ?? ""
                self.majorTextField = authenticationViewModel.userModel?.major ?? ""
                self.graduationYearPicker = authenticationViewModel.userModel?.graduationYear ?? -1
                self.bioTextField = authenticationViewModel.userModel?.bio ?? ""
                Amplitude.instance().logEvent("Edit Profile Screen - View", withEventProperties: propertiesDict)
            }
    }
}

//struct SetupStudentProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(profileViewModel: ProfileViewModel())
//    }
//}
