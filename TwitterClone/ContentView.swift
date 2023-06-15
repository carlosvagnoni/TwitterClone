//
//  ContentView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMenu = false
    @State private var userSessionChanged = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        Group {
            
            if authViewModel.userSession == nil {
                
                LoginView()
                
            } else {
                
                mainInterfaceView
                
            }
            
        }
        .onAppear {
                    print("DEBUG: ContentView userSession is \(authViewModel.userSession)")
                }
        .onReceive(authViewModel.$userSession) { _ in
                    userSessionChanged.toggle()
                }
    }
}

extension ContentView {
    
    var mainInterfaceView: some View {
        
        ZStack(alignment: .topLeading) {
            
            MainTabView()
                .navigationBarHidden(showMenu ? true : false)
            
            if showMenu {
                
                ZStack {
                    
                    Color(.black)
                        .opacity(showMenu ? 0.25 : 0.0)
                    
                }
                .onTapGesture {
                    
                    withAnimation(.easeInOut) {
                        
                        showMenu = false
                        
                    }
                }
                .ignoresSafeArea()
                
            }
            
            SideMenuView()
                .frame(width: 300)
                .background(.white)
                .offset(x: showMenu ? 0 : -300)
            
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                
                if let user = authViewModel.currentUser {
                    
                    Button {
                        
                        withAnimation(.easeInOut) {
                            
                            showMenu = true
                            
                        }
                        
                    } label: {
                        
                        AsyncImage( url: URL(string: user.profilePhotoUrl) )
                        { image in
                            
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                            
                        } placeholder: {
                            
                            ZStack {
                                
                                Circle()
                                    .foregroundColor(Color(.systemGray4))
                                
                                ProgressView()
                                
                            }
                            
                        }
                            .frame(width: 32, height: 32)
                        
                    }
                    
                }
                
            }
    }
        .onAppear {
            
            showMenu = false
            
        }

        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView()
            .environmentObject(AuthViewModel())
        
    }
}
