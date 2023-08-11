//
//  ConversationRowView.swift
//  TwitterClone
//
//  Created by user239477 on 7/20/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct ConversationRowView: View {
    @State var isConfirmationViewPresented = false
    
    @ObservedObject var conversationRowViewModel: ConversationRowViewModel
    
    init(recentMessage: RecentMessage) {
        self.conversationRowViewModel = ConversationRowViewModel(recentMessage: recentMessage)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                if !conversationRowViewModel.recentMessage.read {
                    Color(.systemBlue).opacity(0.1)
                        .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 12) {
                            
                            if let receiverUser = conversationRowViewModel.recentMessage.receiverUser {
                                
                                //Profile Image
                                KFImage(URL(string: receiverUser.profilePhotoUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 56, height: 56)
                                    .foregroundColor(Color(.systemBlue))
                                
                                
                                //User info + Comment
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    //User info
                                    HStack(spacing: 2.5) {
                                        
                                        Text(receiverUser.fullname)
                                            .font(.subheadline).bold()
                                            .truncationMode(.tail)
                                            .lineLimit(1)
                                            .layoutPriority(2)
                                        
                                        Text(" @\(receiverUser.username)")
                                            .bold(conversationRowViewModel.recentMessage.read ? false : true)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                            .truncationMode(.tail)
                                            .lineLimit(1)
                                            .layoutPriority(1)
                                        
                                        Text(" · \(DateFormatterUtils.formatTimestamp(conversationRowViewModel.recentMessage.timestamp))")
                                            .bold(conversationRowViewModel.recentMessage.read ? false : true)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .layoutPriority(3)

                                        Spacer()
                                    }
                                    
                                    //Last message
                                    Text(conversationRowViewModel.recentMessage.text)
                                        .bold(conversationRowViewModel.recentMessage.read ? false : true)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                }
                                
                            } else {
                                
                                //Profile Image
                                Circle()
                                    .scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .modifier(Shimmer())
                                
                                //User info + Comment
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    //User info
                                    HStack(spacing: 2.5) {
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(height: 8)
                                            .cornerRadius(5)
                                            .font(.subheadline).bold()
                                            .modifier(Shimmer())
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(height: 8)
                                            .cornerRadius(5)
                                            .font(.subheadline)
                                            .modifier(Shimmer())
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(height: 8)
                                            .cornerRadius(5)
                                            .font(.subheadline)
                                            .modifier(Shimmer())
                                    }
                                    
                                    //Comment
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(height: 8)
                                        .cornerRadius(5)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .modifier(Shimmer())
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    .padding(12)
                    
                    Divider()
                        .background(Color("dividerColor"))
                }
            }
        }
        .contentShape(Rectangle())
        .frame(minHeight: 80)
    
    }
}

struct ConversationRowView_Previews: PreviewProvider {
    
    static let recentMessage = RecentMessage(senderId: "Mpkv6Jxr0odghQj9oh58FKZSuXj1", text: "Prueba", read: false, timestamp: Timestamp(date: Date()), receiverUser: User(username: "charles_leclerc", fullname: "Charles Leclerc", profilePhotoUrl: "https://firebasestorage.googleapis.com:443/v0/b/twitterclone-39f99.appspot.com/o/profile_image%2FFDD2CFDA-BAF3-4CE7-8930-70F22E90B369?alt=media&token=4deeecea-34a8-4857-a23d-88db16ce8801", email: "charlesleclerc@mail.com"))
    
    static var previews: some View {
        ConversationRowView(recentMessage: recentMessage)
    }
}
