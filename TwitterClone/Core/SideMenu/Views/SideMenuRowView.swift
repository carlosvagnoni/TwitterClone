//
//  SideMenuRowView.swift
//  TwitterClone
//
//  Created by user239477 on 6/3/23.
//

import SwiftUI

struct SideMenuRowView: View {
    
    let sideMenuViewModel: SideMenuViewModel
    
    var body: some View {
        
        HStack {
            
            Image(systemName: sideMenuViewModel.imageName)
            
            Text(sideMenuViewModel.title)
            
        }
        .foregroundColor(.primary)
        .frame(height: 40)
        
    }
}

struct SideMenuRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SideMenuRowView(sideMenuViewModel: .profile)
        
    }
}
