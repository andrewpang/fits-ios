//
//  SignUpViewController.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/25/22.
//

import UIKit
import Foundation
import FirebaseAuth
import PhoneNumberKit
import Amplitude

class SignupSMSViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: EmailSignUpCoordinator?
    var authenticationViewModel: AuthenticationViewModel?
    var profileViewModel: ProfileViewModel?
    
    var phoneNumberTextField: PhoneNumberTextField!
    var confirmNumberButton: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarView()
        setupBackgroundView()
        setupQuestionLabel()
        setupExplanationLabel()
        setupPhoneNumberTextField()
        setupConfirmNumberButton()
        
        //dismissKeyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let propertiesDict = ["isProfilePictureSet": profileViewModel?.image != nil] as [String : Any]
        Amplitude.instance().logEvent("SMS Sign Up Screen - View", withEventProperties: propertiesDict)
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
        let attributedString = NSMutableAttributedString(string: "What is your phone number?")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 100))
        questionLabel.center = CGPoint(x: self.view.frame.size.width/2, y: 100)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.attributedText = attributedString
        questionLabel.font = UIFont(name: Constants.titleFontBold, size: Constants.onboardingTextSize)
        questionLabel.textColor = UIColor.black
        self.view.addSubview(questionLabel)
    }
    
    fileprivate func setupExplanationLabel() {
        let attributedString = NSMutableAttributedString(string: "We will send you a confirmation code, so you can sign-in")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let explanationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 200))
        explanationLabel.center = CGPoint(x: self.view.frame.size.width/2, y: 180)
        explanationLabel.textAlignment = .center
        explanationLabel.numberOfLines = 0
        explanationLabel.attributedText = attributedString
        explanationLabel.font = UIFont(name: Constants.bodyFont, size: 18)
        explanationLabel.textColor = UIColor.black
        self.view.addSubview(explanationLabel)
    }
    
    fileprivate func setupPhoneNumberTextField() {
        phoneNumberTextField = PhoneNumberTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 50))
        phoneNumberTextField.withFlag = true
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.withPrefix = true
        
        phoneNumberTextField.center = CGPoint(x: self.view.frame.size.width/2, y: 260)
        phoneNumberTextField.font = UIFont(name: Constants.bodyFont, size: 24)
        phoneNumberTextField.textContentType = .telephoneNumber
        phoneNumberTextField.borderStyle = UITextField.BorderStyle.roundedRect
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        phoneNumberTextField.layer.cornerRadius = 5.0
        phoneNumberTextField.layer.borderWidth = 1.0
        phoneNumberTextField.layer.masksToBounds = true
        self.view.addSubview(phoneNumberTextField)

        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
    }
    
    fileprivate func setupConfirmNumberButton() {
        confirmNumberButton = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        confirmNumberButton.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 - 20)
        confirmNumberButton.text = "Next"
        confirmNumberButton.font = UIFont(name: Constants.buttonFont, size: Constants.buttonFontSize)
        confirmNumberButton.textColor = UIColor.black
        confirmNumberButton.textAlignment = .center
        confirmNumberButton.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target:self, action: #selector(confirmNumberClicked))
        confirmNumberButton.addGestureRecognizer(labelTapGesture)
        confirmNumberButton.layer.cornerRadius = Constants.buttonCornerRadius
        confirmNumberButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        confirmNumberButton.clipsToBounds = true
        self.view.addSubview(confirmNumberButton)
    }
    
    @objc func confirmNumberClicked(_ sender: Any) {
        phoneNumberTextField.endEditing(true)
        guard let phoneNumberText = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phoneNumberText.isEmpty else { return }
        
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumberText)
            confirmNumberButton.isUserInteractionEnabled = false
            sentPhoneNumberToFirebase(to: phoneNumberText)
//            Amplitude.instance()?.logEvent("Send Magic Link")
            UserDefaults.standard.set(phoneNumberText, forKey: Constants.phoneNumberKey)
            let checkSMSVC = CheckSMSViewController()
            checkSMSVC.delegate = self.delegate
            checkSMSVC.authenticationViewModel = self.authenticationViewModel
            checkSMSVC.profileViewModel = self.profileViewModel
            self.present(checkSMSVC, animated: true, completion: nil)
            confirmNumberButton.isUserInteractionEnabled = true
        }
        catch {
            print("Phone number parser error: textFieldDidEndEditing")
            displayError()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        confirmNumberButton.isUserInteractionEnabled = true
    }
    
    private func sentPhoneNumberToFirebase(to phoneNumber: String) {    
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              guard let verificationId = verificationID, error == nil else {
                  //show error
                  self.displayError()
                  return
              }
              UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          }
    }
    
    func displayError() {
        let attributedString = NSMutableAttributedString(string: "Please enter valid phone number")
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
