//
//  SwiftUIView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var exploreViewModel = ExploreViewModel()
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(exploreViewModel.users) { user in
                        
                        NavigationLink {
                            
                            ProfileView(user: user)
                            
                        } label: {
                            
                            UserRowView(user: user)
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        
        
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ExploreView()
        
    }
}
