//
//  LoginView.swift
//  TwitterClone
//
//  Created by user239477 on 6/6/23.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                
                Text("Hello.")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                
            }
            .foregroundColor(.white)
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBlue))
            
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        LoginView()
        
    }
}
