//
//  CustomInputField.swift
//  TwitterClone
//
//  Created by user239477 on 6/7/23.
//

import SwiftUI

struct CustomTextField: View {
    
    let imageName: String
    let placeholderText: String

    @Binding var text: String
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                TextField(placeholderText, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
            }
            .padding(.bottom, 8)
            
            Divider()
                .background(Color(.darkGray))
            
        }
        
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CustomTextField(imageName: "envelope", placeholderText: "Email", text: .constant(""))
        
    }
}
