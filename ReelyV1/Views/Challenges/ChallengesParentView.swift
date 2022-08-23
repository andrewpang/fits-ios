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
            VStack(spacing: 0) {
                Text("Weekly Challenges")
                    .font(Font.custom(Constants.titleFontBold, size: 36))
                Text("Every Sunday, we'll release a new challenge blah blah blah blah blah blah blah")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                if let challengeModels = challengesViewModel.challengesData.challengeModels, !challengeModels.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(challengeModels, id: \.id) { challengeModel in
                                Button(action: {
                                    //If going to participate, show post
                                    //If not blurred, show challenge view
                                }) {
                                    ChallengesRowView(challengeModel: challengeModel)
                                        .padding(.bottom, 8)
                                }
                            }
                        }
                    }
                } else {
                    Text("Sorry, there's no challenges at the moment :(")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                        .padding(16)
                }
//                Text(challengesViewModel.challengesData.challengeModels?[0].title ?? "hi")
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.horizontal, 16)
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
