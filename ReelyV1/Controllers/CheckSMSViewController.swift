//
//  CheckSMSViewController.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/27/22.
//

import UIKit
import Foundation
import FirebaseAuth

class CheckSMSViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: EmailSignUpCoordinator?
    var authenticationViewModel: AuthenticationViewModel?
    
    var confirmNumberButton: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarView()
        setupBackgroundView()
        setupQuestionLabel()
        setupExplanationLabel()
        setupSMSCodeTextField()
        setupConfirmNumberButton()
        
        //dismissKeyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func setupNavBarView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    fileprivate func setupBackgroundView() {
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupQuestionLabel() {
        let attributedString = NSMutableAttributedString(string: "Enter code sent to your phone")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 100))
        questionLabel.center = CGPoint(x: self.view.frame.size.width/2, y: 100)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.attributedText = attributedString
        questionLabel.font = UIFont.boldSystemFont(ofSize: Constants.onboardingTextSize)
        questionLabel.textColor = UIColor.black
        self.view.addSubview(questionLabel)
    }
    
    fileprivate func setupExplanationLabel() {
        let normalText = "We sent a 6-digit code to "
        let boldText = UserDefaults.standard.string(forKey: Constants.phoneNumberKey) ?? "your phone number"
        let italicText = ". (You may have to wait a few seconds)"
        
        let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
        let boldAttrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let italicAttrs = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 18)]
        
        let attributedString = NSMutableAttributedString(string:normalText, attributes: normalAttrs)
        let boldString = NSMutableAttributedString(string: boldText, attributes:boldAttrs)
        let italicString = NSMutableAttributedString(string:italicText, attributes: italicAttrs)
        
        attributedString.append(boldString)
        attributedString.append(italicString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let explanationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 200))
        explanationLabel.center = CGPoint(x: self.view.frame.size.width/2, y: 200)
        explanationLabel.numberOfLines = 0
        explanationLabel.attributedText = attributedString
        explanationLabel.textColor = UIColor.black
        self.view.addSubview(explanationLabel)
    }
    
    fileprivate func setupSMSCodeTextField() {
        let SMSCodeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 50))

        SMSCodeTextField.center = CGPoint(x: self.view.frame.size.width/2, y: 280)
        SMSCodeTextField.placeholder = "Enter code"
        SMSCodeTextField.font = .systemFont(ofSize: 24)
        SMSCodeTextField.textContentType = .oneTimeCode
        SMSCodeTextField.borderStyle = UITextField.BorderStyle.roundedRect
        SMSCodeTextField.layer.borderColor = UIColor.black.cgColor
        SMSCodeTextField.layer.cornerRadius = 5.0
        SMSCodeTextField.layer.borderWidth = 1.0
        SMSCodeTextField.layer.masksToBounds = true
        self.view.addSubview(SMSCodeTextField)
        
        SMSCodeTextField.becomeFirstResponder()
        SMSCodeTextField.delegate = self
    }
    
    fileprivate func setupConfirmNumberButton() {
        confirmNumberButton = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 60))
        confirmNumberButton.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        confirmNumberButton.text = "Confirm"
        confirmNumberButton.font = UIFont.systemFont(ofSize: 20)
        confirmNumberButton.textColor = UIColor.white
        confirmNumberButton.textAlignment = .center
        confirmNumberButton.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target:self, action: #selector(confirmNumberClicked))
        confirmNumberButton.addGestureRecognizer(labelTapGesture)
        confirmNumberButton.layer.cornerRadius = 5.0
        confirmNumberButton.layer.borderWidth = 1.0
        confirmNumberButton.layer.borderColor = UIColor.black.cgColor
        confirmNumberButton.layer.backgroundColor = UIColor.black.cgColor
        confirmNumberButton.clipsToBounds = true
        self.view.addSubview(confirmNumberButton)
    }
    
    @objc func confirmNumberClicked(_ sender: Any) {
//        .endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        confirmNumberButton.isUserInteractionEnabled = true
    }
    
    func displayError() {
        let attributedString = NSMutableAttributedString(string: "Please enter valid code")
        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 200))
        errorLabel.center = CGPoint(x: self.view.frame.size.width/2, y: 320)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.attributedText = attributedString
        errorLabel.font = UIFont.systemFont(ofSize: 18)
        errorLabel.textColor = UIColor.red
        self.view.addSubview(errorLabel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
//        if segue.identifier == Constants.showCheckEmailSegue {
//            let destinationVC = segue.destination as! CheckEmailViewController
//            destinationVC.email = phoneNumberTextField.text
//            destinationVC.authenticationViewModel = authenticationViewModel
//        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        confirmNumberButton.isUserInteractionEnabled = false
//        phoneNumberTextField.endEditing(true)
//        guard let email = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else { return true }
//        sendSignInLink(to: email)
//        return true
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        animateViewMoving(up: true, moveValue: 100)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        animateViewMoving(up: false, moveValue: 100)
//    }
    
//    func animateViewMoving (up:Bool, moveValue :CGFloat){
//        let movementDuration:TimeInterval = 0.3
//        let movement:CGFloat = ( up ? -moveValue : moveValue)
//
//        UIView.beginAnimations("animateView", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration)
//
//        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//        UIView.commitAnimations()
//    }
}
