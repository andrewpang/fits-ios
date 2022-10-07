//
//  TagsView.swift
//  FITs
//
//  Created by Andrew Pang on 10/7/22.
//

import SwiftUI

struct TagsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Spacer()
//                ForEach(Array(zip(self.tabBarOptions.indices,
//                                      self.tabBarOptions)),
//                        id: \.0,
//                        content: {
//                        index, name in
//                            CategoryTabBarItem(
//                                currentTab: self.$currentTab,
//                                selectedCategoryTag: self.$selectedCategoryTag,
//                                namespace: namespace.self,
//                                tabBarItemName: name,
//                                tab: index
//                            )
//                        })
                TagView(title: "#casual", isSelected: false)
                TagView(title: "#streetwear", isSelected: false)
                TagView(title: "#designer", isSelected: false)
                TagView(title: "#grunge", isSelected: false)
                TagView(title: "#y2k", isSelected: false)
                TagView(title: "#80s", isSelected: false)
                TagView(title: "#90s", isSelected: false)
                TagView(title: "#cottagecore", isSelected: false)
                Spacer()
            }
        }.onTapGesture { // Hacky fix for nested clicks to work
        }
//        .frame(height: 40)
    }
}

struct TagView: View {
    let title: String
    @State var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.custom(Constants.bodyFont, size: 16))
                .lineLimit(1)
        }.padding(.horizontal, 12)
        .padding(.vertical, 4)
        .foregroundColor(isSelected ? .white : .gray)
        .background(isSelected ? Color.gray : Color.white)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.gray, lineWidth: 1.0)
        ).padding(.vertical, 2)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView()
    }
}
