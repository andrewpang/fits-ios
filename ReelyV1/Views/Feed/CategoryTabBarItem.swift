//
//  CategoryTabBarItem.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI

struct CategoryTabBarItem: View {
    @Binding var currentTab: Int
    @Binding var selectedCategoryTag: String
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
            VStack(spacing: 4) {
                Spacer()
                if currentTab == tab {
                    Text(tabBarItemName).font(Font.custom(Constants.bodyFont, size: 16))
                    Color(Constants.darkBackgroundColor)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Text(tabBarItemName).font(Font.custom(Constants.bodyFont, size: 16)).foregroundColor(.gray)
                    Color.clear.frame(height: 2)
                }
                Spacer()
            }.padding(.horizontal, 12)
            .animation(.spring(), value: self.currentTab)
            .onTapGesture {
                self.currentTab = tab
                self.selectedCategoryTag = tabBarItemName.lowercased()
            }
    }
}
