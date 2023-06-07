//
//  RegistrationView.swift
//  TwitterClone
//
//  Created by user239477 on 6/6/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    
    var body: some View {
        
        VStack {
            
            AuthHeaderView(title1: "Get started.", title2: "Create your account")
            
            VStack(spacing: 40) {
                
                CustomTextField(imageName: "envelope", placeholderText: "Email", text: $email)
                
                CustomTextField(imageName: "person", placeholderText: "Username", text: $username)
                
                CustomTextField(imageName: "person", placeholderText: "Full name", text: $fullname)
                
                CustomSecureField(imageName: "lock", placeholderText: "Password", password: $password)
                
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 44)
            
            Button {
                
                print("Sign up here...")
                
            } label: {
                
                Text("Sign Un")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
                
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            NavigationLink {
                
                LoginView()
                    .toolbar(.hidden)
                
            } label: {
                
                HStack {
                    
                    Text("Already have an account?")
                        .font(.footnote)
                    
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                }
            }
            .padding(.bottom, 32)
            .foregroundColor(Color(.systemBlue))
            
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
        
    }
}

struct RegistrationView_Previews: PreviewProvider {
    
    static var previews: some View {
        

            
            RegistrationView()
            

        
    }
}
