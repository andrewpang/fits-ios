//
//  GalleryFeedView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import PermissionsSwiftUINotification
import FirebaseMessaging
import Amplitude
import WaterfallGrid

struct GalleryFeedView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showNotificationPermissionModal = false
    @State var fcmToken = ""
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    
    func requestNotificationPermissions() {
        Messaging.messaging().delegate = UIApplication.shared as? MessagingDelegate
        UNUserNotificationCenter.current().delegate = UIApplication.shared as? UNUserNotificationCenterDelegate
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission success!")
                DispatchQueue.main.async {
//                    let propertiesDict = ["permissionType": "notification", "permissionAllowed": true] as [String : Any]
//                    Amplitude.instance().logEvent("User Permission Requested", withEventProperties: propertiesDict)
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
//                let propertiesDict = ["permissionType": "notification", "permissionAllowed": false] as [String : Any]
//                Amplitude.instance().logEvent("User Permission Requested", withEventProperties: propertiesDict)
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: PostDetailView(homeViewModel: homeViewModel, postDetailViewModel: postDetailViewModel), isActive: $homeViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                Color(Constants.backgroundColor).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    if let postModels = homeViewModel.postsData.postModels {
                        WaterfallGrid(postModels) { post in
                            Button(action: {
                                postDetailViewModel = PostDetailViewModel(postModel: post)
                                homeViewModel.shouldPopToRootViewIfFalse = true
                            }, label: {
                                PostCardView(post: post)
                            })
                        }
                        .gridStyle(
                            columnsInPortrait: 2,
                            columnsInLandscape: 3,
                            spacing: 8,
                            animation: .easeInOut(duration: 0.5)
                        )
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                }
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .JMAlert(showModal: $showNotificationPermissionModal, for: [.notification], restrictDismissal: false, autoDismiss: true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            self.authenticationViewModel.checkIfSignedIn()
            requestNotificationPermissions()
            self.homeViewModel.fetchPosts(isAdmin: authenticationViewModel.userModel?.groups?.contains(Constants.adminGroupId) ?? false)
            Amplitude.instance().logEvent("Home Feed Screen - View")
        }
    }
}
