//
//  SplashScreenView.swift
//  TwitterClone
//
//  Created by user244558 on 8/11/23.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            Color(colorScheme == .dark ? .black : .systemBlue)
                .ignoresSafeArea()
            
            HStack(spacing: 0.0) {
                Image(colorScheme == .dark ? "appLogoBlack" : "appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170)
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
