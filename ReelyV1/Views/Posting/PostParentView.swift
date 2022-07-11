//
//  PostParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/27/22.
//

import SwiftUI

struct PostParentView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            PostCategoriesView(homeViewModel: homeViewModel)
        }
    }
}
