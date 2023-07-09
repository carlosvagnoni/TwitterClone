//
//  DeleteTweetConfirmationView.swift
//  TwitterClone
//
//  Created by user239477 on 7/9/23.
//

import SwiftUI

struct DeleteTweetConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Text("Do you want to delete this tweet?")
                    .font(.title)
                    .padding()

                HStack {
                    Button("Yes") {

                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)

                    Button("No") {
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
            
        }
}

struct DeleteTweetConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteTweetConfirmationView()
    }
}
