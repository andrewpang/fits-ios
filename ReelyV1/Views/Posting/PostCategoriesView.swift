//
//  PostCategoriesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/1/22.
//

import SwiftUI

struct PostCategoriesView: View {
    @State var pickerResult: UIImage?
    @State var showPicker = false
    @State var showSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var navigateToNextPage = false
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: AddPostView(homeViewModel: HomeViewModel(), authenticationViewModel: AuthenticationViewModel(), pickerResult: $pickerResult), isActive: $navigateToNextPage) {
                    EmptyView()
                }
                Text("What do you want to share with the FIT(s) Community?").font(Font.system(size: 24)).foregroundColor(.black).bold()
                
                Button(action: {
                    showSheet = true
                }, label: {
                    VStack {
                        Text("Fit Pic (OOTD)").font(Font.system(size: 24)).foregroundColor(.black).bold()
                        Text("Show off your creativity and post your daily looks!").font(Font.system(size: 16)).foregroundColor(.gray)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    .background(Color.white)
                    .cornerRadius(Constants.buttonCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                            .stroke(.black, lineWidth: Constants.buttonBorderWidth)
                    )
                }).actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                        .default(Text("Photo Library")) {
                            self.showPicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text("Camera")) {
                            self.showPicker = true
                            self.sourceType = .camera
                        },
                        .cancel()
                    ])
                }.padding(.vertical, 8)
//
//                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
//                    VStack {
//                        Text("Help Me Get Ready").font(Font.system(size: 24)).foregroundColor(.black).bold()
//                        Text("Post two outfits and let the community decide!").font(Font.system(size: 16)).foregroundColor(.gray)
//                    }
//                    .padding(.vertical, 16)
//                    .padding(.horizontal, 24)
//                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
//                    .background(Color.white)
//                    .cornerRadius(Constants.buttonCornerRadius)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
//                            .stroke(.black, lineWidth: Constants.buttonBorderWidth)
//                    )
//                }.padding(.vertical, 8)
//
//                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
//                    VStack {
//                        Text("Product Review").font(Font.system(size: 24)).foregroundColor(.black).bold()
//                        Text("Bought something new? Tell us about it!").font(Font.system(size: 16)).foregroundColor(.gray)
//                    }
//                    .padding(.vertical, 16)
//                    .padding(.horizontal, 24)
//                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
//                    .background(Color.white)
//                    .cornerRadius(Constants.buttonCornerRadius)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
//                            .stroke(.black, lineWidth: Constants.buttonBorderWidth)
//                    )
//                }.padding(.vertical, 8)
//
//                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
//                    VStack {
//                        Text("Text Post").font(Font.system(size: 24)).foregroundColor(.black).bold()
//                        Text("Post questions or discussions").font(Font.system(size: 16)).foregroundColor(.gray)
//                    }
//                    .padding(.vertical, 16)
//                    .padding(.horizontal, 24)
//                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
//                    .background(Color.white)
//                    .cornerRadius(Constants.buttonCornerRadius)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
//                            .stroke(.black, lineWidth: Constants.buttonBorderWidth)
//                    )
//                }.padding(.vertical, 8)
                
            }.padding(24)
            .sheet(isPresented: $showPicker) {
                ImagePicker(selectedImage: $pickerResult, isPresented: $showPicker, sourceType: sourceType).onDisappear {
                    if (pickerResult != nil) {
                        self.navigateToNextPage = true
                    }
                }
            }
        }
    }
}

struct PostCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        PostCategoriesView()
    }
}
