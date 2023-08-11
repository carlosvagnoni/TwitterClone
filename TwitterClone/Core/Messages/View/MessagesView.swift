//
//  MessagesView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    
    @State private var selectedUser: User?
    
    @State private var showUserListView = false
    
    @State private var shouldNavigateToConversation = false
    @State var isConfirmationViewPresented = false
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    var body: some View {        
        
        ZStack(alignment: .bottomTrailing) {
            if let receiverUser = selectedUser {
                
                NavigationLink(isActive: $shouldNavigateToConversation) {
                    ConversationView(receiverUser: receiverUser)
                } label: {
                }
            }
            
            if messagesViewModel.isLoading {
                VStack {
                    ProgressView()
                        .tint(Color(.systemBlue))
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                if messagesViewModel.recentMessages.isEmpty {
                    
                    VStack(spacing: 0) {
                        Text("Tap 'New Message' icon to start a conversation")
                            .bold()
                            .foregroundColor(.gray)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(messagesViewModel.recentMessages) { recentMessage in
                                
                                if let user = recentMessage.receiverUser {
                                    
                                    ConversationRowView(recentMessage: recentMessage)
                                        .onTapGesture {
                                            self.selectedUser = user
                                            self.shouldNavigateToConversation = true
                                            
                                            if !recentMessage.read {
                                                messagesViewModel.readConversation(receiverID: user.id!)
                                            }
                                            
                                        }
                                        .onLongPressGesture {
                                            self.selectedUser = user
                                            isConfirmationViewPresented = true
                                        }
                                }
                            }
                        }
                    }
                }
            }
            
            Button {
                showUserListView = true
            } label: {
                VStack {
                    
                    Image(systemName: "envelope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .padding()
                    
                }
                .background(Color(.systemBlue))
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
            }
            
        }
        .onAppear() {
            messagesViewModel.fetchRecentMessages()
        }
        .fullScreenCover(isPresented: $showUserListView) {
            MessageRecipientListView(selectedUser: $selectedUser, shouldNavigateToConversation: $shouldNavigateToConversation)
        }
        .sheet(isPresented: $isConfirmationViewPresented) {
            DeleteConversationView(receiverId: (selectedUser?.id)!)
                .presentationDetents([.fraction(0.25)])
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
            .environmentObject(MessagesViewModel())
    }
}
