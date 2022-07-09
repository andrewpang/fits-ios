//
//  LoadingSplashScreenView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/31/22.
//

import SwiftUI

struct LoadingSplashScreenView: View {
    var body: some View {
        Text("FIT(s)")
            .font(Font.custom(Constants.titleFontBold, size: 60))
            .foregroundColor(.black)
    }
}

struct LoadingSplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSplashScreenView()
    }
}
