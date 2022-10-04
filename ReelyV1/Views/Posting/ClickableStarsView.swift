//
//  ClickableStarsView.swift
//  FITs
//
//  Created by Andrew Pang on 10/4/22.
//

import SwiftUI

struct ClickableStarsView: View {
    private static let MAX_RATING: Int = 5 // Defines upper limit of the rating
    private static let COLOR = Color.yellow // The color of the stars
    private static let STAR_SIZE: CGFloat = 24

    @Binding var rating: Int?
    
//    init() {
////        fullCount = Int(rating)
////        emptyCount = Int(ClickableStarsView.MAX_RATING - rating)
//    }
//
//    init(rating: Int) {
//        self.rating = rating
//        fullCount = Int(rating)
//        emptyCount = Int(ClickableStarsView.MAX_RATING - rating)
//    }

    var body: some View {
        HStack {
            ForEach(1..<ClickableStarsView.MAX_RATING + 1) { i in
                ZStack {
                    if (rating ?? -1 >= i) {
                        self.fullStar
                    } else {
                        self.emptyStar
                    }
                }.onTapGesture { self.rating = i }
            }
            
        }
    }

    private var fullStar: some View {
        Image(systemName: "star.fill").foregroundColor(ClickableStarsView.COLOR).font(.system(size: ClickableStarsView.STAR_SIZE))
    }

    private var emptyStar: some View {
        Image(systemName: "star").foregroundColor(ClickableStarsView.COLOR).font(.system(size: ClickableStarsView.STAR_SIZE))
    }
}
