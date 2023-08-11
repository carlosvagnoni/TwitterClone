//
//  MessageRecipientListView.swift
//  TwitterClone
//
//  Created by user239477 on 7/21/23.
//

import SwiftUI

struct MessageRecipientListView: View {
    @Binding var selectedUser: User?
    @Binding var shouldNavigateToConversation: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var messageRecipientListViewModel = MessageRecipientListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                SearchBar(text: $messageRecipientListViewModel.searchText)
                    .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        let usersToShow = messageRecipientListViewModel.searchText.isEmpty ? messageRecipientListViewModel.users : messageRecipientListViewModel.searchableUsers
                        
                        ForEach(usersToShow) { user in
                            Button {
                                dismiss()
                                self.selectedUser = user
                                self.shouldNavigateToConversation = true
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New message")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                    .padding(0)
                }
            }
        }
    }
}

//struct MessageRecipientListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRecipientListView()
//    }
//}
