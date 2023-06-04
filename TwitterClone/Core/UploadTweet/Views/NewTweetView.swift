//
//  NewTweetView.swift
//  TwitterClone
//
//  Created by user239477 on 6/4/23.
//

import SwiftUI

struct NewTweetView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var caption = ""
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button {
                    
                    dismiss()
                    
                } label: {
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                    
                }
                
                Spacer()
                
                Button {
                    
                    print("Tweet")
                    
                } label: {
                    
                    Text("Tweet")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                    
                }
   
            }
            .padding(12)
            
            HStack {
                
                Circle()
                    .frame(width: 40, height: 40)
                
                TextArea("What's happening?", text: $caption)
                
                
            }
            
        }
        
    }
}

struct NewTweetView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NewTweetView()
        
    }
}
