//
//  NotificationRowView.swift
//  TwitterClone
//
//  Created by user239477 on 7/17/23.
//

import SwiftUI
import Firebase

struct NotificationRowView: View {
    @ObservedObject var notificationRowViewModel: NotificationRowViewModel
    
    @State var navigateToTweetView = false
    
    init(notification: Notification) {
        self.notificationRowViewModel = NotificationRowViewModel(notification: notification)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                if !notificationRowViewModel.notification.read {
                    Color(.systemBlue).opacity(0.1)
                        .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    if let tweet = notificationRowViewModel.notification.tweet {
                        NavigationLink(destination: TweetView(tweet: tweet), isActive: $navigateToTweetView) {
                            EmptyView()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 12) {
                            
                            //Imagen notification type
                            Image(systemName: notificationRowViewModel.notification.notificationType.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .foregroundColor(notificationRowViewModel.notification.notificationType.imageColor)
                            
                            //Notification info
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 2.5) {
                                    
                                    Text("\(notificationRowViewModel.notification.senderFullname!) \(notificationRowViewModel.notification.notificationType.message)")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .bold(notificationRowViewModel.notification.read ? false : true)
                                    
                                    Spacer()
                                }
                                
                                Text("\(DateFormatterUtils.formatTimestamp(notificationRowViewModel.notification.timestamp))")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .bold(notificationRowViewModel.notification.read ? false : true)
                            }                            
                        }
                    }
                    .padding(12)
                    
                    Divider()
                        .background(Color("dividerColor"))
                }
                .frame(minHeight: 50)
            }
            
        }
        .onTapGesture {
            notificationRowViewModel.readNotification()
            navigateToTweetView = true
        }
    }
}

struct NotificationRowView_Previews: PreviewProvider {    
    static var previews: some View {
        NotificationRowView(notification: Notification.MOCK_NOTIFICATION)
    }
}
