//
//  UserRowView.swift
//  TwitterClone
//
//  Created by user239477 on 6/2/23.
//

import SwiftUI

struct UserRowView: View {
    
    var body: some View {
        
        HStack {
            
            Circle()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Daniel Ricciardo")
                    .font(.subheadline).bold()
                
                Text("@thehoneybadger")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            
            Spacer()
            
        }
        .padding(12)
        
    }
}

struct UserRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        UserRowView()
        
    }
}
