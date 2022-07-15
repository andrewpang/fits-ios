//
//  EmailSignUpControllerWrapper.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/25/22.
//

import Foundation
import SwiftUI

struct SignUpControllerWrapper : UIViewControllerRepresentable {
    typealias UIViewControllerType = SignupSMSViewController
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var authenticationViewModel : AuthenticationViewModel
    
    var popToPrevious : Bool = false {
        didSet {
            if popToPrevious == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func makeCoordinator() -> EmailSignUpCoordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpControllerWrapper>) -> SignUpControllerWrapper.UIViewControllerType {
        let signUpViewController = SignupSMSViewController()
        signUpViewController.delegate = context.coordinator
        signUpViewController.authenticationViewModel = authenticationViewModel
        signUpViewController.profileViewModel = profileViewModel
        return signUpViewController
    }

    func updateUIViewController(_ uiViewController: SignUpControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpControllerWrapper>) {
        //
    }
}

class EmailSignUpCoordinator: NSObject, UINavigationControllerDelegate {
    var parent: SignUpControllerWrapper
    
    init(_ viewController : SignUpControllerWrapper) {
        self.parent = viewController
    }
    
    func dismissView() {
        parent.popToPrevious = true
    }
}
