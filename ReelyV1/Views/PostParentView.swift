//
//  PostParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/27/22.
//

import SwiftUI

struct PostParentView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State var pickerResult: UIImage = UIImage(named: "placeHolder")!
   
    var body: some View {
        ZStack {
            AddPostView(homeViewModel: homeViewModel, authenticationViewModel: authenticationViewModel, pickerResult: $pickerResult)
            if (homeViewModel.showYPImagePickerView) {
                MediaPicker(homeViewModel: homeViewModel, pickerResult: $pickerResult)
            }
        }.navigationTitle("Add Post")
        
    }
}

//struct PostParentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostParentView(tabSelection: <#T##Binding<Int>#>)
//    }
//}
