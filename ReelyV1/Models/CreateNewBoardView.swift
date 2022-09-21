//
//  CreateNewBoardView.swift
//  FITs
//
//  Created by Andrew Pang on 9/21/22.
//

import SwiftUI
import Kingfisher

struct CreateNewBoardView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @State var boardTitle = ""
    @State var isSubmitting = false
    
    enum FocusField: Hashable {
      case field
    }

    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing:0) {
                KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: postDetailViewModel.postModel.imageUrls?.first ?? "", width: CloudinaryHelper.thumbnailWidth)))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 151)
                    .clipped()
                    .cornerRadius(Constants.buttonCornerRadius, corners: [.topLeft, .bottomLeft])
                Divider()
                    .frame(width: 1, height: 151)
                    .overlay(.white)
                VStack(spacing:0){
                    Rectangle().fill(Color(Constants.onBoardingButtonColor))
                        .frame(width: 100, height: 75)
                        .cornerRadius(Constants.buttonCornerRadius, corners: [.topRight])
                    Divider()
                        .frame(width: 100, height: 1)
                        .overlay(.white)
                    Rectangle().fill(Color(Constants.onBoardingButtonColor))
                        .frame(width: 100, height: 75)
                        .cornerRadius(Constants.buttonCornerRadius, corners: [.bottomRight])
                }
            }.padding(.vertical, 16)
            Text("Board Name:")
                .font(Font.custom(Constants.titleFontBold, size: 18))
            Text("Required (Max. 30 Characters)")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .foregroundColor(.gray)
            TextField("Title", text: $boardTitle)
                .font(Font.custom(Constants.titleFont, size: 18))
                .disabled(isSubmitting)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onReceive(boardTitle.publisher.collect()) {
                    let s = String($0.prefix(Constants.postTitleCharacterLimit))
                    if boardTitle != s {
                        boardTitle = s
                    }
                }
                .focused($focusedField, equals: .field)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                        self.focusedField = .field
                    }
                }
            Button(action: {
                
            }) {
                HStack {
                    Text("Create")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(Color(Constants.backgroundColor))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
                .background(Color(Constants.darkBackgroundColor))
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
            }.padding(.vertical, 8)
            Spacer()
        }
        .navigationBarTitle("Create Board", displayMode: .inline)
        .padding(.horizontal, 24)
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button(action: {
//                    //analytics
//                    //submit board
//                    isSubmitting = true
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }) {
//                    if (self.boardTitle.isEmpty) {
//                        HStack {
//                           Text("Create")
//                                .font(Font.custom(Constants.bodyFont, size: 16))
//                        }.padding(.vertical, 4)
//                        .padding(.horizontal, 16)
//                        .background(Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .opacity(0.75)
//                    } else {
//                        HStack {
//                            if (isSubmitting) {
//                                Text("Loading...")
//                                    .font(Font.custom(Constants.bodyFont, size: 16))
//                            } else {
//                                Text("Create")
//                                    .font(Font.custom(Constants.bodyFont, size: 16))
//                            }
//                        }.padding(.vertical, 4)
//                        .padding(.horizontal, 16)
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                }
//                .disabled(self.boardTitle.isEmpty || self.isSubmitting == true)
//            }
//        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
