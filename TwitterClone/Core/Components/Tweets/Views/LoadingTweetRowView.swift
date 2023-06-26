//
//  LoadingTweetRowView.swift
//  TwitterClone
//
//  Created by user239477 on 6/25/23.
//

import SwiftUI

struct LoadingTweetRowView: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                //Profile image + User info + Tweet
                HStack(alignment: .top, spacing: 12) {
                    
                    //Profile Image
                    Circle()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .modifier(Shimmer())
                              
                    //User info + Tweet caption
                    VStack(alignment: .leading, spacing: 4) {
                        
                        //User info
                        
                        HStack(spacing: 2.5) {
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 8)
                                .cornerRadius(5)
                                .font(.subheadline).bold()
                                .modifier(Shimmer())
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 8)
                                .cornerRadius(5)
                                .font(.subheadline)
                                .modifier(Shimmer())
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 8)
                                .cornerRadius(5)
                                .font(.subheadline)
                                .modifier(Shimmer())
                        }

                        //Tweet caption
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(height: 8)
                            .cornerRadius(5)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .modifier(Shimmer())
                        
                    }
                    
                }
                
                //Action buttons
                HStack {
                    
                    HStack {
                        
                    }
                    .frame(width: 56)
                    .padding(.trailing, 3)
                    
                    HStack {
                        
                        Image(systemName: "bubble.left")
                            .font(.subheadline)
                            .modifier(Shimmer())
                        
                        Spacer()
                                                                        
                        Image(systemName: "arrow.2.squarepath")
                            .font(.subheadline)
                            .modifier(Shimmer())
                        
                        Spacer()
                                                
                        Image(systemName: "heart")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .modifier(Shimmer())
                                                
                        Spacer()
                        
                        Image(systemName: "bookmark")
                            .font(.subheadline)
                            .modifier(Shimmer())
                        
                    }
                    .padding(.top, 12)
                    .foregroundColor(.gray)
                }
                
                
                
            }
            .padding(12)
            
            Divider()
            
        }
        .frame(minHeight: 110)
        
    }
}


struct LoadingTweetRowView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingTweetRowView()
    }
}
