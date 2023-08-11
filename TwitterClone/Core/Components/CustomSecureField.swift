//
//  CustomSecureField.swift
//  TwitterClone
//
//  Created by user239477 on 6/7/23.
//

import SwiftUI

struct CustomSecureField: View {
    
    let imageName: String
    let placeholderText: String
    
    @State var showPassword: Bool = false
    
    @Binding var password: String
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                ZStack(alignment: .leading) {
                    
                    if password.isEmpty {
                        Text(verbatim: placeholderText)
                            .foregroundColor(Color(.placeholderText))
                    }
                    
                    if showPassword {
                        
                        TextField(text: $password) {
                            Text(verbatim: placeholderText)
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .opacity(showPassword ? 1 : 0)
                    } else {
                        SecureField("", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .opacity(showPassword ? 0 : 1)
                    }
                }
                
                if !password.isEmpty {
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                            .padding(.trailing, 12)
                            .foregroundColor(Color(.darkGray))
                    }
                }
            }
            .frame(height: 25)
            .padding(.bottom,8)
            
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomSecureField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureField(imageName: "lock", placeholderText: "Password", password: .constant("Perro"))
    }
}
