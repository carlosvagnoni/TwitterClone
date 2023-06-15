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
            
            SearchBar(text: $exploreViewModel.searchText)
                .padding(.top, 10)
            
            if exploreViewModel.searchText.isEmpty {
                
                VStack(spacing: 0) {
                    
                    Text("Try searching for people")
                        .bold()
                        .foregroundColor(.gray)
                        .padding(20)
                    
                    Spacer()
                    
                }
                
            } else {
                
                ScrollView {
                    
                    LazyVStack(spacing: 0) {
                        
                        ForEach(exploreViewModel.searchableUsers) { user in
                            
                            NavigationLink {
                                
                                ProfileView(user: user)
                                
                            } label: {
                                
                                UserRowView(user: user)
                                
                            }
                            
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
        
        NavigationView {
            
            ExploreView()
            
        }
        
    }
}
