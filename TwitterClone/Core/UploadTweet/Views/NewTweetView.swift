//
//  NewTweetView.swift
//  TwitterClone
//
//  Created by user239477 on 6/4/23.
//

import SwiftUI
import Kingfisher
import PhotosUI
import AVKit

struct NewTweetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    @ObservedObject var uploadTweetViewModel = UploadTweetViewModel()
    
    @State private var caption = ""
    @State var selectedItem: PhotosPickerItem?
    @State private var selectedPhoto: UIImage?
    @State private var isVideoProcessing: Bool = false
    @State private var isTweetBeingUploaded: Bool? = false
    
    @State private var selectedVideoUrl: URL?
    @State private var selectedVideoData: Data?
    @State private var mediaType: MediaType?
    
    var body: some View {
        
        ZStack {
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
                        if let mediaType = mediaType {
                            switch mediaType {
                            case .image:
                                isTweetBeingUploaded = true
                                uploadTweetViewModel.uploadTweet(caption: caption, image: selectedPhoto) { success in
                                    isTweetBeingUploaded = false
                                }
                            case .video:
                                isTweetBeingUploaded = true
                                uploadTweetViewModel.uploadTweet(caption: caption, videoData: selectedVideoData) { success in
                                    isTweetBeingUploaded = false
                                }
                            }
                        } else {
                            isTweetBeingUploaded = true
                            uploadTweetViewModel.uploadTweet(caption: caption) { success in
                                isTweetBeingUploaded = false
                            }
                        }
                        
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
                
                HStack(alignment: .top, spacing: 0) {
                    
                    if let user = authViewModel.currentUser {
                        
                        KFImage(URL(string: user.profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .padding(12)
                        
                    }
                    
                    
                    VStack {
                        TextArea("What's happening?", text: $caption)
                        
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
                            }
                        }
                        
                        
                        
                        Spacer()
                        
                    }
                    
                    
                                   
                    
                }
                
                Spacer()
                
                Divider()
                
                HStack(spacing: 0) {
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
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 12)
                
            }
            

            if isTweetBeingUploaded ?? false {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(Color(.systemBlue))
                    .scaleEffect(2)
           }
            
        }
        
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

        .onReceive(uploadTweetViewModel.$didUploadTweet) { success in
            
            if success {
                
                feedViewModel.fetchTweets()
                
                dismiss()
                
            } else {
                
                // Handle error here...
                
            }
        }
        
    }
}

struct VideoPickerTransferable: Transferable {
    let videoUrl: URL
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.videoUrl)
        } importing: { ReceivedTransferredFile in
            let originalFile = ReceivedTransferredFile.file
            let copiedFile = URL.documentsDirectory.appending(path: "videoPicker.mov")
            if FileManager.default.fileExists(atPath: copiedFile.path()) {
                try FileManager.default.removeItem(at: copiedFile)
            }
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(videoUrl: copiedFile)
        }

    }
}

struct NewTweetView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NewTweetView()
            .environmentObject(AuthViewModel())
        
    }
}
