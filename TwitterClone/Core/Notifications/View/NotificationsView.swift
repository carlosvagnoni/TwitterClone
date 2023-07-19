//
//  NotificationsView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct NotificationsView: View {
    
    @EnvironmentObject var notificationsViewModel: NotificationsViewModel
    
    var body: some View {
        
        VStack {
            
            if notificationsViewModel.isLoading {

                VStack {
                    ProgressView()
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {
                    
                    ScrollView {
                        
                        LazyVStack(spacing: 0) {
                            
                            ForEach(notificationsViewModel.notifications) { notification in
                                
                                NotificationRowView(notification: notification)
                                
                            }
                        }
                        
                    }
            }
            
        }
        .onAppear() {            
            notificationsViewModel.fetchNotifications()  
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NotificationsView()
        
    }
}
