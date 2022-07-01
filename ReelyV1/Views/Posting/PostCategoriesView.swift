//
//  PostCategoriesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/1/22.
//

import SwiftUI

struct PostCategoriesView: View {
    @State var pickerResult: UIImage = UIImage(named: "placeHolder")!
    
    var body: some View {
        ScrollView {
            VStack {
                Text("What do you want to share with the FIT(s) Community?").font(Font.system(size: 24)).foregroundColor(.black).bold()
                
                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
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
                }.padding(.vertical, 8)
                
                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
                    VStack {
                        Text("Help Me Get Ready").font(Font.system(size: 24)).foregroundColor(.black).bold()
                        Text("Post two outfits and let the community decide!").font(Font.system(size: 16)).foregroundColor(.gray)
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
                }.padding(.vertical, 8)
                
                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
                    VStack {
                        Text("Product Review").font(Font.system(size: 24)).foregroundColor(.black).bold()
                        Text("Bought something new? Tell us about it!").font(Font.system(size: 16)).foregroundColor(.gray)
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
                }.padding(.vertical, 8)
                
                NavigationLink(destination: MediaPicker(pickerResult: $pickerResult)) {
                    VStack {
                        Text("Text Post").font(Font.system(size: 24)).foregroundColor(.black).bold()
                        Text("Post questions or discussions").font(Font.system(size: 16)).foregroundColor(.gray)
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
                }.padding(.vertical, 8)
                
            }.padding(24)
        }
    }
}

struct PostCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        PostCategoriesView()
    }
}
