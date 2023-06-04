//
//  SwiftUIView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct ExploreView: View {
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(0...25, id: \.self) { _ in
                        
                        NavigationLink {
                            
                            ProfileView()
                            
                        } label: {
                            
                            UserRowView()
                            
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
