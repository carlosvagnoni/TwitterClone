//
//  LoginView.swift
//  TwitterClone
//
//  Created by user239477 on 6/6/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        
                        Text("Hello.")
                            .font(.largeTitle)
                        .fontWeight(.semibold)
                        
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                        
                }
   
                
            }
            .foregroundColor(.white)
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBlue))
            .clipShape(RoundedShape(corners: [.bottomRight]))
            
            VStack(spacing: 40) {
                
                TextField("Email", text: $email)
                
                TextField("Password", text: $password)
                
            }
            .padding(.horizontal, 32)
            .padding(.top, 44)
            
            HStack {
                
                Spacer()
                
                NavigationLink {
                    
                    Text("Reset password view...")
                    
                } label: {
                    
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top)
                        .padding(.trailing
                        , 24)
                    
                }
   
            }
            
            Button {
                
                print("Sign in here...")
                
            } label: {
                
                Text("Sign In")
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
                
                RegistrationView()
                    .toolbar(.hidden)
                
            } label: {
                
                HStack {
                    
                    Text("Dont have an account?")
                        .font(.footnote)
                    
                    Text("Sign Up")
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

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NavigationStack {
            
            LoginView()
            
        }
        
    }
}
