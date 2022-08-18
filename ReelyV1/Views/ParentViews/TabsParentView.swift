//
//  TabsParentView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import SwiftUI

let homeIndex = 1

struct TabsParentView: View {
    @StateObject var tabViewModel: TabViewModel = TabViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @State var lastTabSelection = homeIndex
    
    var body: some View {
        ZStack {
            TabView(selection: $tabViewModel.tabSelection.onUpdate {
                if (lastTabSelection == tabViewModel.tabSelection) {
                    if (lastTabSelection == homeIndex) {
                        homeViewModel.shouldPopToRootViewIfFalse = false
                    }
                    //TODO(REE-243): Pop profile tab to root
                }
                lastTabSelection = tabViewModel.tabSelection
            }) {
                GalleryFeedView(homeViewModel: homeViewModel)
                    .tabItem {
                       Image(systemName: "house")
                       Text("Home")
                     }.tag(homeIndex)
                PostParentView(homeViewModel: homeViewModel)
                 .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Post")
                  }.tag(2)
                ProfileParentView()
                 .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                  }.tag(3)
            }.accentColor(Color(Constants.darkBackgroundColor))
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            if (homeViewModel.showIntroPostOverlay) {
                FirstPostOverlayView(homeViewModel: homeViewModel)
            }
        }
        .environmentObject(tabViewModel)
    }
}

//Need to use this binding to get clicks on the active tab
extension Binding {
 func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
    Binding(get: {
        wrappedValue
    }, set: { newValue in
        wrappedValue = newValue
        closure()
    })
 }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        TabsParentView()
    }
}
