//
//  ConversationView.swift
//  TwitterClone
//
//  Created by user239477 on 7/21/23.
//

import SwiftUI
import Kingfisher
import PhotosUI
import AVKit

struct ConversationView: View {
    
    @State var selectedItem: PhotosPickerItem?
    @State private var newMessage = ""
    
    @State private var selectedPhoto: UIImage?
    @State private var isVideoProcessing: Bool = false
    @State private var isMessageBeingUploaded: Bool? = false
    
    @State private var selectedVideoUrl: URL?
    @State private var selectedVideoData: Data?
    @State private var mediaType: MediaType?
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    @StateObject var conversationViewModel: ConversationViewModel
    
    
        init (receiverUser: User) {
            self._conversationViewModel = StateObject(wrappedValue: ConversationViewModel(receiverUser: receiverUser))
        }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
                if conversationViewModel.isLoading {
                    
                    VStack {
                        ProgressView()
                            .tint(Color(.systemBlue))
                            .scaleEffect(2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    
                    ScrollView {
                        ScrollViewReader { proxy in
                            LazyVStack {
                                ForEach(conversationViewModel.messages) { message in
                                    MessageRowView(message: message)
                                        .id(message.id)
                                }
                            }
                            .onChange(of: conversationViewModel.messages.count) { _ in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    if let lastMessage = conversationViewModel.messages.last {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                            .onAppear {
                                withAnimation {
                                    if let lastMessage = conversationViewModel.messages.last {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 12)


                    
                    
                    HStack(alignment: .top) {
                        PhotosPicker(selection: $selectedItem,
                                     matching: .any(of: [.images, .videos])
    //                                 matching: .images
                        ) {
                            
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .foregroundColor(Color(.systemBlue))
                            
                        }
                        .padding(.top, 10)
                        
                        VStack(spacing: 0) {
                            TextArea("Start a message", text: $newMessage)
                            
                            if let mediaType = mediaType {
                                switch mediaType {
                                case .image:
                                    if let selectedPhoto = selectedPhoto {
                                        
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedPhoto)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .padding(.horizontal, 12)
                                            
                                            Button {
                                                self.selectedPhoto = nil
                                                self.mediaType = nil
                                            } label: {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(.black.opacity(0.5))
                                                    Image(systemName: "xmark")
                                                        .resizable()
                                                        .frame(width: 12, height: 12)
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 24)
                                                .padding(.vertical, 12)
                                            }

                                        }
                                        .frame(maxHeight: 250)
                                        
                                        
                                    }
                                case .video:
                                    ZStack(alignment: .topLeading) {
                                        if let selectedVideoUrl {
                                            VStack {
                                                VideoPlayer(player: .init(url: selectedVideoUrl))
                                            }
                                            .frame(maxHeight: 400)
                                            .padding(.horizontal, 12)
                                                
                                            Button {
                                                self.selectedVideoUrl = nil
                                                self.mediaType = nil
                                                selectedVideoData = nil
                                            } label: {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(.black.opacity(0.5))
                                                    Image(systemName: "xmark")
                                                        .resizable()
                                                        .frame(width: 12, height: 12)
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 24)
                                                .padding(.vertical, 12)
                                            }
                                        }
                                        if isVideoProcessing {
                                            Rectangle()
                                                .fill(.ultraThinMaterial)
                                                .overlay {
                                                    ProgressView()
                                                        .tint(Color(.systemBlue))
                                                }
                                        }
                                    }
                                    .frame(maxHeight: 250)
                                }
                            }

                        }
                        
                        
                        Spacer()
                        
                        Button {
                            guard let receiverId = conversationViewModel.receiverUser.id else {return}
                            if let mediaType = mediaType {
                                switch mediaType {
                                case .image:
                                    isMessageBeingUploaded = true
                                    conversationViewModel.sendMessage(receiverId: receiverId, text: newMessage, image: selectedPhoto) {
                                        isMessageBeingUploaded = false
                                        selectedPhoto = nil
                                        self.mediaType = nil
                                        newMessage = ""
                                    }
                                case .video:
                                    isMessageBeingUploaded = true
                                    conversationViewModel.sendMessage(receiverId: receiverId, text: newMessage, videoData: selectedVideoData) {
                                        isMessageBeingUploaded = false
                                        selectedVideoUrl = nil
                                        self.mediaType = nil
                                        selectedVideoData = nil
                                        newMessage = ""
                                    }
                                }
                            } else {
                                isMessageBeingUploaded = true
                                conversationViewModel.sendMessage(receiverId: receiverId, text: newMessage) {
                                    isMessageBeingUploaded = false
                                    newMessage = ""
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 38, height: 38)
                                    .foregroundColor(Color(.systemBlue))
                                
                                Image(systemName: "triangle.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 15)
                                    .rotationEffect(.degrees(90))
                                    .offset(x: 2)
                                
                            }
                            .padding(.top, 6)
                        }
                        

                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 12)
                    .padding(.top, 5)

                }
            }
            
            if isMessageBeingUploaded ?? false {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(Color(.systemBlue))
                    .scaleEffect(2)
           }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                
                HStack {

                    Button {

                        dismiss()

                    } label: {

                        Image(systemName: "arrow.left.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)

                    }
                    
                    NavigationLink {
                        ProfileView(user: conversationViewModel.receiverUser)
                    } label: {
                        KFImage(URL(string: conversationViewModel.receiverUser.profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 32, height: 32)
                    }
                    
                    Text(conversationViewModel.receiverUser.fullname)
                        .font(.headline)
                                  
                }
                
                
                
                
                
            }
            
        }
        .toolbarBackground(.visible)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let contentTypes = selectedItem?.supportedContentTypes {
                    for type in contentTypes {
                        if type.conforms(to: UTType.image) {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                mediaType = .image
                                selectedPhoto = UIImage(data: data)
                                break
                            }
                        } else if type.conforms(to: UTType.movie) {
                            mediaType = .video
                            
                            Task {
                                isVideoProcessing = true
                                let selectedVideo = try await  newItem?.loadTransferable(type: VideoPickerTransferable.self)
                                if let data = try await newItem? .loadTransferable(type: Data.self) {
                                    selectedVideoData = data
                                }
                                isVideoProcessing = false
                                selectedVideoUrl = selectedVideo?.videoUrl
                            }
                            break
                        }
                    }
                }
            }
        }
        .onAppear {
            messagesViewModel.currentConversationUserId = conversationViewModel.receiverUser.id
            
            }
            .onDisappear {
                messagesViewModel.currentConversationUserId = nil
            }
    }
}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ConversationView()
//        }
//    }
//}
