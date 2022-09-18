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
    @State var currentTab: Int = 0
    
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
                    CategoryTabBarView(currentTab: self.$currentTab)
                    TabView(selection: self.$currentTab) {
                        WaterfallCollectionViewController(homeViewModel: homeViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController()).tag(0)
                        WaterfallCollectionRandomFeedView(homeViewModel: homeViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController()).tag(1)
                        WaterfallCollectionViewController(homeViewModel: homeViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController()).tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
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

struct CategoryTabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] = ["Following", "For You", "Most Recent"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                      self.tabBarOptions)),
                        id: \.0,
                        content: {
                        index, name in
                            CategoryTabBarItem(currentTab: self.$currentTab,
                                namespace: namespace.self,
                                tabBarItemName: name,
                                tab: index)
                        
                        })
            }.padding(.horizontal, 24)
        }
        .frame(height: 40)
    }
}

struct CategoryTabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack(spacing: 4) {
                Spacer()
                if currentTab == tab {
                    Text(tabBarItemName).font(Font.custom(Constants.bodyFont, size: 16))
                    Color(Constants.darkBackgroundColor)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Text(tabBarItemName).font(Font.custom(Constants.bodyFont, size: 16)).foregroundColor(.gray)
                    Color.clear.frame(height: 2)
                }
                Spacer()
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
