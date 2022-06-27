//
//  EmailSignUpControllerWrapper.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/25/22.
//

import Foundation
import SwiftUI

struct EmailSignUpControllerWrapper : UIViewControllerRepresentable {
    typealias UIViewControllerType = SignUpViewController
    
    @Environment(\.presentationMode) var presentationMode
    
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
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EmailSignUpControllerWrapper>) -> EmailSignUpControllerWrapper.UIViewControllerType {
        let signUpViewController = SignUpViewController()
        signUpViewController.delegate = context.coordinator
        return signUpViewController
    }

    func updateUIViewController(_ uiViewController: EmailSignUpControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<EmailSignUpControllerWrapper>) {
        //
    }
}

class EmailSignUpCoordinator: NSObject, UINavigationControllerDelegate {
    var parent: EmailSignUpControllerWrapper
    
    init(_ viewController : EmailSignUpControllerWrapper) {
        self.parent = viewController
    }
    
    func dismissView() {
        parent.popToPrevious = true
    }
}
