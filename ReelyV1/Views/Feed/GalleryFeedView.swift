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
import Mixpanel

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
                NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "homeFeed"), isActive: $homeViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                .onAppear {
                    self.homeViewModel.postsSeenThisSession += 1
                    self.homeViewModel.checkIfShouldShowIntroPostOverlay()
                }
                Color(Constants.backgroundColor).ignoresSafeArea()
                VStack(spacing: 0) {
                    Text(Constants.appTitle)
                        .tracking(4)
                        .font(Font.custom(Constants.titleFontItalicized, size: 32))
                        .padding(.bottom, 4)
                    WaterfallCollectionViewController(homeViewModel: homeViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController())
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
            self.homeViewModel.fetchPromptPostsForUser(with: authenticationViewModel.userModel?.id ?? "noId")
            self.homeViewModel.fetchPostLikesForUser(with: authenticationViewModel.userModel?.id ?? "noId")
            let eventName = "Home Feed Screen - View"
            Amplitude.instance().logEvent(eventName)
            Mixpanel.mainInstance().track(event: eventName)
//            for family in UIFont.familyNames {
//              print("family:", family)
//              for font in UIFont.fontNames(forFamilyName: family) {
//                  print("font:", font)
//              }
//            }
        }
    }
}
