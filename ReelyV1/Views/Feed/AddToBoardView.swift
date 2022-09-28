//
//  AddToBoardView.swift
//  FITs
//
//  Created by Andrew Pang on 9/21/22.
//

import SwiftUI
import Amplitude
import Mixpanel

struct AddToBoardView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showCreateNewBoardView = false
    @State var showUnbookmarkAlert = false
    @State var showRemoveFromBoardAlert = false
    @State var removedFromBoardPopup = false
    @State var selectedBookmarkBoard = BookmarkBoardModel()
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CreateNewBoardView(postDetailViewModel: postDetailViewModel), isActive: $showCreateNewBoardView) {
                    EmptyView()
                }
                HStack {
                    Button(action: {
                        postDetailViewModel.isShowingBoardsSheet = false
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18.0))
                            .foregroundColor(Color(Constants.darkBackgroundColor))
                    })
                    Spacer()
                    Text("Save to board")
                        .font(Font.custom(Constants.titleFontBold, size: 24))
                        
                    Spacer()
                    Button(action: {
                        generator.notificationOccurred(.warning)
                        showUnbookmarkAlert = true
                    }) {
                        Image(systemName: "bookmark.slash.fill")
                            .font(.system(size: 18.0))
                            .foregroundColor(.red)
                    }
                }.padding(24)
                if let bookmarkBoardsList = postDetailViewModel.usersBookmarkBoardsList, !bookmarkBoardsList.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(bookmarkBoardsList, id: \.id) { bookmarkBoardModel in
                                Button(action: {
                                    if let boardId = bookmarkBoardModel.id {
                                        if let postId = postDetailViewModel.postModel.id {
                                            if let bookmarkerId = authenticationViewModel.userModel?.id {
                                                if let boardIds = postDetailViewModel.bookmarkData.boardIds, boardIds.contains(boardId) {
                                                    generator.notificationOccurred(.warning)
                                                    selectedBookmarkBoard = bookmarkBoardModel
                                                    showRemoveFromBoardAlert = true
                                                } else {
                                                    generator.notificationOccurred(.success)
                                                    postDetailViewModel.addBookmarkToBoard(postId: postId, previewImageUrl: postDetailViewModel.postModel.getFirstImageUrl(), bookmarkerId: bookmarkerId, boardId: boardId)
                                                    postDetailViewModel.isShowingBoardsSheet = false
                                                    postDetailViewModel.isShowingSavedToBoardPopup = true
                                                }
                                            }
                                        }
                                    }
                                }, label: {
                                    if let boardIds = postDetailViewModel.bookmarkData.boardIds, boardIds.contains(bookmarkBoardModel.id ?? "noId") {
                                        AddToBoardRowView(bookmarkBoardModel: bookmarkBoardModel, alreadyAddedToBoard: true)
                                    } else {
                                        AddToBoardRowView(bookmarkBoardModel: bookmarkBoardModel, alreadyAddedToBoard: false)
                                    }
                                })
                            }
                        }
                    }
                } else {
                    Spacer()
                    Text("You haven't created any boards yet :(")
                        .font(Font.custom(Constants.bodyFont, size: 18))
                        .padding(.horizontal, 8)
                        .foregroundColor(Color(Constants.darkBackgroundColor))
                }
                Spacer()
                Divider()
                    .frame(height: 1)
                    .overlay(Color(Constants.darkBackgroundColor))
                Button(action: {
                    showCreateNewBoardView = true
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 32.0, weight: .light))
                            .foregroundColor(Color(Constants.darkBackgroundColor))
                        Text("Create new board")
                            .font(Font.custom(Constants.bodyFont, size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16.0, weight: .light))
                            .foregroundColor(Color(Constants.darkBackgroundColor))
                    }.padding(.horizontal, 24)
                    .contentShape(Rectangle())
                }).buttonStyle(PlainButtonStyle())

            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .alert("Remove from Collections", isPresented: $showUnbookmarkAlert, actions: {
                  Button("Cancel", role: .cancel, action: {})
                  Button("Remove", role: .destructive, action: {
                      if let bookmarkerId = authenticationViewModel.userModel?.id {
                          postDetailViewModel.unbookmarkPost(bookmarkerId: bookmarkerId)
                          postDetailViewModel.isShowingBoardsSheet = false
                          postDetailViewModel.isShowingRemovedFromCollectionsPopup = true
                      }
                  })
                }, message: {
                    Text("Are you sure you want to remove this post from your collections?")
                })
            .alert("Remove from Board", isPresented: $showRemoveFromBoardAlert, actions: {
                  Button("Cancel", role: .cancel, action: {})
                  Button("Remove", role: .destructive, action: {
                      if let postId = postDetailViewModel.postModel.id {
                          if let bookmarkerId = authenticationViewModel.userModel?.id {
                              if let bookmarkBoardId = selectedBookmarkBoard.id {
                                  postDetailViewModel.removeBookmarkFromBoard(postId: postId, bookmarkerId: bookmarkerId, boardId: bookmarkBoardId)
                                  removedFromBoardPopup = true
                              }
                          }
                      }
                  })
                }, message: {
                    Text("Are you sure you want to remove this post from this board?")
                })
            .popup(isPresented: $removedFromBoardPopup, type: .floater(verticalPadding: 16, useSafeAreaInset: true), position: .top, autohideIn: 2) {
                HStack {
                    Text("🙅‍♀️")
                        .font(Font.custom(Constants.buttonFont, size: 16))
                        .foregroundColor(.white)
                    Text("Removed from board")
                        .font(Font.custom(Constants.buttonFont, size: 16))
                        .foregroundColor(Color(Constants.backgroundColor))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(Constants.darkBackgroundColor))
                .opacity(0.9)
                .cornerRadius(Constants.buttonCornerRadius)
            }
            .onAppear {
                postDetailViewModel.fetchBookmarkBoardsForUser(with: authenticationViewModel.userModel?.id ?? "noId")
                let eventName = "Add To Board - View"
                let propertiesDict = ["postId": postDetailViewModel.postModel.id] as? [String : String]
                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
        }
    }
}
