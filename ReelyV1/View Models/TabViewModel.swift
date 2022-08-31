//
//  TabViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/2/22.
//

import Foundation

class TabViewModel: ObservableObject {
    @Published var tabSelection = 1
    
    func showPromptTab() {
        DispatchQueue.main.async {
            self.tabSelection = 2
        }
    }
}
