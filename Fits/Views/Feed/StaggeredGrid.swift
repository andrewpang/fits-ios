//
//  StaggeredGrid.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable{
    
    var content: (T) -> Content
    
    var list: [T]
    
    var columns: Int
    
    var showsIndicators: Bool
    var spacing: CGFloat
    
    init(columns: Int = 2, showsIndicators: Bool = false, spacing: CGFloat = 10, list: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.columns = columns
    }
    
    func setUpList() -> [[T]] {
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex = 0
        for object in list {
            gridArray[currentIndex].append(object)
            
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        return gridArray
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators, content: {
            HStack (alignment: .top) {
                ForEach(setUpList(), id: \.self) { columnsData in
                    LazyVStack (spacing: spacing) {
                        ForEach(columnsData) { object in
                            content(object)
                        }
                    }
                }
            }
            .padding(.vertical)
        })
    }
}

//struct StaggeredGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        StaggeredGrid()
//    }
//}
