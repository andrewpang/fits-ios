//
//  SetupUserView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/30/22.
//

import SwiftUI
import Kingfisher

struct SetupUserView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State var profilePic: UIImage? = nil
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Add profile photo").bold().padding(.top, 32)
            Text("Add a profile photo so that people can recognize you (optional)").font(Font.system(size: 14)).foregroundColor(.gray)
            HStack (alignment: .center) {
                Spacer()
                Button(action: {
                    
                }, label: {
                    if let pic = profilePic {
                        Image(uiImage: pic)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    } else {
                        KFImage(URL(string: "https://www.nacdnet.org/wp-content/uploads/2016/06/person-placeholder.jpg"))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 175, height: 175, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                })
                Spacer()
            }
            
            Text("Choose a display name:").bold().padding(.top, 40)
            Text("Choose a name to display on our app, it doesn't have to be a real name").font(Font.system(size: 14)).foregroundColor(.gray)
            TextField("Display Name", text: $authenticationViewModel.displayName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button(action: {
//                authenticationViewModel.state = .signedIn
                authenticationViewModel.signUp()
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }).padding(.top, 40)
        }.padding()
        .navigationTitle("Profile Setup")
    }
}

struct SetupUserView_Previews: PreviewProvider {
    static var previews: some View {
        SetupUserView(authenticationViewModel: AuthenticationViewModel())
    }
}
