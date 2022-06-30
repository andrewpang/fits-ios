//
//  SetupStudentProfileView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/29/22.
//

import SwiftUI

struct SetupStudentProfileView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("What's your major?").bold()
                    Spacer()
                }
                TextField("Your major", text: $profileViewModel.major)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("What's your graduation year?").bold()
                    Spacer()
                }
                Picker("", selection: $profileViewModel.graduationYear) {
                    ForEach(2022...2026, id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Group {
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
        }.padding(24)
        .navigationTitle("FIT Profile")
    }
}

struct SetupStudentProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetupStudentProfileView(profileViewModel: ProfileViewModel())
    }
}
