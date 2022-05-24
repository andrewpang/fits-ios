//
//  HomeViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var postsData = PostsModel()
}
