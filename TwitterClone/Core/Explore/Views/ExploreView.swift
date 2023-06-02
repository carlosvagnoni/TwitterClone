//
//  SwiftUIView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct ExploreView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    LazyVStack {
                        
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
        }
        
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ExploreView()
        
    }
}
