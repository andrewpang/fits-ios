//
//  GalleryFeedView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import PermissionsSwiftUINotification
import FirebaseMessaging

struct GalleryFeedView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @State var showNotificationPermissionModal = false
    @State var fcmToken = ""
    
    func requestNotificationPermissions() {
        Messaging.messaging().delegate = UIApplication.shared as? MessagingDelegate
        UNUserNotificationCenter.current().delegate = UIApplication.shared as? UNUserNotificationCenterDelegate
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission success!")
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
                Messaging.messaging().token { token, error in
                  if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                  } else if let token = token {
                    print("FCM registration token: \(token)")
                    self.fcmToken = token
                  }
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.15).ignoresSafeArea()
                StaggeredGrid(columns: 2, list: homeViewModel.postsData.postModels ?? [], content: { post in
                    NavigationLink(destination: PostDetailView(postDetailViewModel: PostDetailViewModel(postModel: post)),
                                       label: {
                            PostCardView(post: post)
                        })
                }).padding(.horizontal)
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .JMAlert(showModal: $showNotificationPermissionModal, for: [.notification], restrictDismissal: false, autoDismiss: true)
        }
        .onAppear {
            requestNotificationPermissions()
            self.homeViewModel.fetchPosts()
        }
    }
}
