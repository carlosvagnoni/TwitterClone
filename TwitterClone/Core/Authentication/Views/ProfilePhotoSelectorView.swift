//
//  PhotoSelectorView.swift
//  TwitterClone
//
//  Created by user239477 on 6/11/23.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoSelectorView: View {
    
    @State var selectedItem: PhotosPickerItem?
    @State private var profilePhoto: Image?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            AuthHeaderView(title1: "Setup account", title2: "Add a profile photo")
            
            PhotosPicker(selection: $selectedItem,
                         matching: .images) {
                
                ZStack {
                    
                    if let profilePhoto = profilePhoto {
                        
                        profilePhoto
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                    } else {
                        
                        Image("emptyProfilePhoto")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                    }
                    
                    Circle()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                        .offset(x: 0, y: 50)
                    
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 50)
                      
                }
                
            }
                         .padding(.top, 44)
                         .onChange(of: selectedItem) { newItem in
                             Task {
                                 
                                 if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                     
                                     profilePhoto = Image(uiImage: UIImage(data: data)!)
                                     
                                 }
                             }
                         }
            
            if profilePhoto != nil {
                
                Button {
                    
                    
                    
                } label: {
                    
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                    
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                .padding(.top, 32)
  
            }
            
            Spacer()
            
        }
        .ignoresSafeArea()
        
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ProfilePhotoSelectorView()
        
    }
}
