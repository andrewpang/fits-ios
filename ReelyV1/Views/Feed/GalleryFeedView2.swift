//
//  GalleryFeedView2.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI
import PermissionsSwiftUINotification
import FirebaseMessaging
import Amplitude
import Mixpanel

struct GalleryFeedView2: View {
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
                    if let postModels = homeViewModel.postsData.postModels {
                        WaterfallCollectionViewController(postsModel: $homeViewModel.postsData, uiCollectionViewController: UICollectionViewController())
                    }
                    
//                    ScrollView(.vertical, showsIndicators: false) {
//                        if let postModels = homeViewModel.postsData.postModels {
//                            WaterfallGrid(postModels) { post in
//                                Button(action: {
//                                    postDetailViewModel = PostDetailViewModel(postModel: post)
//                                    homeViewModel.shouldPopToRootViewIfFalse = true
//                                }, label: {
//                                    PostCardView(post: post)
//                                })
//                            }
//                            .gridStyle(
//                                columnsInPortrait: 2,
//                                columnsInLandscape: 3,
//                                spacing: 8,
//                                animation: .none
//                            )
//                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
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
