//
//  UserRowView.swift
//  TwitterClone
//
//  Created by user239477 on 6/2/23.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    
    let user: User
    
    var body: some View {
        
        HStack {
            KFImage(URL(string: user.profilePhotoUrl))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullname)
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)
                
                Text("@\(user.username)")
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
        UserRowView(user: User.MOCK_USER)        
    }
}
