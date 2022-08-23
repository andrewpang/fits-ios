//
//  ChallengesParentView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI

struct ChallengesParentView: View {
    
    @StateObject var challengesViewModel = ChallengesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/) 
//                Text(challengesViewModel.challengesData.challengeModels?[0].title ?? "hi")
            }
        }.onAppear {
            challengesViewModel.fetchChallenges()
        }
    }
}

struct ChallengesParentView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesParentView()
    }
}
