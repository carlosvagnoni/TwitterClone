//
//  SideMenuView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 12) {
                
                Circle()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Daniel Ricciardo")
                        .font(.subheadline).bold()
                    
                    Text("@thehoneybadger")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                
                UserStatsView()
                       
            }
            
            Divider()
                .padding(.vertical)
            
            ForEach(SideMenuViewModel.allCases, id: \.rawValue) { option in
                
                HStack {
                    
                    Image(systemName: option.imageName)
                    
                    Text(option.title)
                    
                }
                .frame(height: 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        
    }
}

struct SideMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SideMenuView()
        
    }
}
