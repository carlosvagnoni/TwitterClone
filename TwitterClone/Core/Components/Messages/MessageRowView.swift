//
//  MessageRowView.swift
//  TwitterClone
//
//  Created by user239477 on 7/22/23.
//

import SwiftUI
import Firebase
import Kingfisher
import AVKit

struct MessageRowView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showTime = false
    
    var message: Message
    
    var body: some View {
        let wasSentByCurrentUser = message.senderId == authViewModel.currentUser?.id
        
        VStack(alignment: wasSentByCurrentUser ? .trailing : .leading) {
            VStack(alignment: wasSentByCurrentUser ? .trailing : .leading, spacing: 0) {
                if let messageMediaType = message.mediaType {
                    
                    switch messageMediaType {
                    case .image:
                        KFImage(URL(string: message.mediaURL!))
                            .resizable()
                            .placeholder{
                                ProgressView()
                                    .tint(Color(.systemBlue))
                                    .scaleEffect(2)
                            }
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.top)
                            .padding(.horizontal)
                            .padding(.bottom, message.text.isEmpty ? 16 : 0)
                    case .video:
                        VStack {
                            VideoPlayer(player: AVPlayer(url: URL(string: message.mediaURL!)!))
                                .aspectRatio(contentMode: .fill)
                                .padding(.top)
                                .padding(.horizontal)
                                .padding(.bottom, message.text.isEmpty ? 16 : 0)
                        }
                        .frame(maxHeight: 400)
                    }
                }
                
                if !message.text.isEmpty {
                    Text(message.text)
                        .foregroundColor(wasSentByCurrentUser ? .white : .primary)
                        .padding()
                }                
            }
            .background(
                (wasSentByCurrentUser ? Color(.systemBlue) : Color(.systemGray5))
                    .onTapGesture {
                        showTime.toggle()
                    }
            )
            .cornerRadius(30)
            .frame(maxWidth: 300, alignment: wasSentByCurrentUser ? .trailing : .leading)
            
            if showTime {
                Text(message.timestamp.dateValue().formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: wasSentByCurrentUser ? .trailing : .leading)
        .padding(wasSentByCurrentUser ? .trailing : .leading)
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(message: Message.MOCK_MESSAGE)
            .environmentObject(AuthViewModel())
    }
}
