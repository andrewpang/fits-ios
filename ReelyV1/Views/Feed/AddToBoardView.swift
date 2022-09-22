//
//  AddToBoardView.swift
//  FITs
//
//  Created by Andrew Pang on 9/21/22.
//

import SwiftUI

struct AddToBoardView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var showCreateNewBoardView = false
    @State var showUnbookmarkConfirmationDialog = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Constants.backgroundColor).ignoresSafeArea()
                VStack {
                    NavigationLink(destination: CreateNewBoardView(postDetailViewModel: postDetailViewModel), isActive: $showCreateNewBoardView) {
                        EmptyView()
                    }
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
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
                            showUnbookmarkConfirmationDialog = true
                        }) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 18.0))
                                .foregroundColor(.red)
                        }
                    }.padding(24)
                    ScrollView {
                        Text("Hi")
                        Text("Hi")
                        Text("Hi")
                        Text("Hi")
                        Text("Hi")
                        Text("Hi")
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
                }
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .confirmationDialog("Remove from Collections", isPresented: $showUnbookmarkConfirmationDialog) {
                Button ("Remove from Collections", role: ButtonRole.destructive) {
                    if let bookmarkerId = authenticationViewModel.userModel?.id {
                        postDetailViewModel.unbookmarkPost(bookmarkerId: bookmarkerId)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
                Text ("Are you sure you want to remove this post from your collections?")
            }
        }
    }
}
