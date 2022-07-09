//
//  SetupStudentProfileView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/29/22.
//

import SwiftUI

struct SetupStudentProfileView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var navigateToNextView = false
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("What class are you?")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                Picker("", selection: $profileViewModel.graduationYear) {
                    ForEach(2023...2026, id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Group {
                HStack {
                    Text("What's your major?")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                TextField("Your major", text: $profileViewModel.major)
                    .font(Font.custom(Constants.titleFont, size: 24))
            }
            
            Group {
                HStack {
                    Text("Describe yourself")
                        .font(Font.custom(Constants.titleFont, size: 24))
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
//                HStack {
//                    Text("Tell us a bit about yourself, what you’re studying, what year you are, etc.")
//                        .font(Font.custom(Constants.bodyFont, size: 16))
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
                TextField("Your bio", text: $profileViewModel.bio)
                    .font(Font.custom(Constants.titleFont, size: 24))
//                    TextEditor(text: $bio)
//                            .overlay(RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray).opacity(0.3))
//                            .frame(minHeight: 60)
            }

            Spacer()
            
            NavigationLink(destination: SignUpControllerWrapper(profileViewModel: profileViewModel), isActive: $navigateToNextView) {
                HStack {
                    Text("Continue")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Color(Constants.onBoardingButtonColor))
                .foregroundColor(.white)
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.vertical, 24)
            }
        }.padding(24)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Skip for now") {
                    self.navigateToNextView = true
                }
            }
        }
    }
}

struct SetupStudentProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetupStudentProfileView(profileViewModel: ProfileViewModel())
    }
}
