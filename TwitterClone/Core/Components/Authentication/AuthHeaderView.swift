//
//  AuthHeaderView.swift
//  TwitterClone
//
//  Created by user239477 on 6/7/23.
//

import SwiftUI

struct AuthHeaderView: View {
    
    let title1: String
    let title2: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(title1)
                        .font(.largeTitle)
                    .fontWeight(.semibold)
                    
                    Text(title2)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .padding(.leading, 12)
                
                Spacer()
            }
        }
        .foregroundColor(.white)
        .frame(height: 260)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBlue))
        .clipShape(RoundedShape(corners: [.bottomRight]))
    }
}

struct AuthHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AuthHeaderView(title1: "Hello.", title2: "Welcome Back")       
    }
}
