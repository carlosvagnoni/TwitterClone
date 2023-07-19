//
//  NotificationsView.swift
//  TwitterClone
//
//  Created by user239477 on 6/1/23.
//

import SwiftUI

struct NotificationsView: View {
    
    @ObservedObject var notificationsViewModel = NotificationsViewModel()
    
    var unreadNotificationsCount: Int {
            return notificationsViewModel.notifications.filter { !$0.read }.count
        }
    
    var body: some View {
        
        VStack {
            
            if notificationsViewModel.isLoading {

                VStack {
                    ProgressView()
                        .scaleEffect(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {
                
                VStack {
                    Text("\(unreadNotificationsCount)")
                    
                    ScrollView {
                        
                        LazyVStack(spacing: 0) {
                            
                            ForEach(notificationsViewModel.notifications) { notification in
                                
                                NotificationRowView(notification: notification)
                                
                            }
                        }
                        
                    }
                }
                
                
                
            }
            
        }
        .onAppear() {            
            notificationsViewModel.fetchNotifications()
            print("HAY \(unreadNotificationsCount) POR LEEAR")
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NotificationsView()
        
    }
}
