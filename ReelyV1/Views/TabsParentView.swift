//
//  TabsParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

struct TabsParentView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var tabViewModel: TabViewModel = TabViewModel()
    
    var body: some View {
        TabView(selection: $tabViewModel.tabSelection) {
            GalleryFeedView(homeViewModel: homeViewModel)
             .tabItem {
                Image(systemName: "house")
                Text("Home")
              }.tag(1)
            PostParentView()
             .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Post")
              }.tag(2)
        }
        .environmentObject(tabViewModel)
        .onChange(of: tabViewModel.tabSelection, perform: { index in
            homeViewModel.fetchPosts()
        })
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        TabsParentView(authenticationViewModel: AuthenticationViewModel())
    }
}
