//
//  ContentView.swift
//  TwitterClone
//
//  Created by user239477 on 5/31/23.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State private var showMenu = false
    @State private var userSessionChanged = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Group {
            
            if authViewModel.userSession == nil {
                
                LoginView()
                
            } else {
                
                mainInterfaceView
                
            }
            
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
                .toolbar(showMenu ? .hidden : .visible)

            
            if showMenu {
                
                ZStack {
                    
                    Color(.black)
                        .opacity(showMenu ? 0.25 : 0.0)
                    
                }
                .onTapGesture {
                       
                    showMenu = false
                }
                .ignoresSafeArea()
                
            }
            
            SideMenuView()
                .frame(width: 300)
                .background(colorScheme == .dark ? .black : .white)
                .offset(x: showMenu ? 0 : -300)
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                
                if let user = authViewModel.currentUser {
                    
                    Button {
                            
                        showMenu = true
                        
                    } label: {
                        
                        KFImage(URL(string: user.profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
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
