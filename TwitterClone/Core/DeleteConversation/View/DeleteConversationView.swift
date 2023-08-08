//
//  DeleteConversationView.swift
//  TwitterClone
//
//  Created by user239477 on 8/5/23.
//

import SwiftUI

struct DeleteConversationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var deleteConversationViewModel: DeleteConversationViewModel
    
    init(receiverId: String) {
        self._deleteConversationViewModel = StateObject(wrappedValue: DeleteConversationViewModel(receiverId: receiverId))
    }
    
    var body: some View {
        
        VStack {
            Text("Do you want to delete this conversation?")
                .font(.title2)
                .padding(12)
            
            HStack {
                Button {
                        deleteConversationViewModel.deleteConversation()
                } label: {
                    Text("Yes")
                        .frame(minWidth: 120)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                }
                
                
                Button {
                    dismiss()
                } label: {
                    Text("No")
                        .frame(minWidth: 120)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(Color(.systemBlue))
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color(.systemBlue), lineWidth: 2)
                        )
                }
            }
        }
        .onReceive(deleteConversationViewModel.$didDeletedConversation) { successVIEW in

            if successVIEW {
                dismiss()
                
            } else {
                
                // Handle error here...
                
            }
        }
        
        
    }
}

//struct DeleteConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteConversationView()
//    }
//}
