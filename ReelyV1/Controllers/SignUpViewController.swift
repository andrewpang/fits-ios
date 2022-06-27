//
//  SignUpViewController.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/25/22.
//

import UIKit
import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: EmailSignUpCoordinator?
    
    var emailField: UITextField!
    var signInButton: UILabel!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0

    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor //#303e67
    let gradientTwo = UIColor(red: 1.00, green: 0.49, blue: 0.19, alpha: 1.00).cgColor //#FF7E30
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor //c4466c

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarView()
//        setupBackgroundView()
        setupQuestionLabel()
        setupExplanationLabel()
        setupEmailTextField()
        setupSignInButton()
        
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
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.drawsAsynchronously = true
        self.view.layer.addSublayer(gradient)
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.repeatCount = Float.infinity
        gradientChangeAnimation.autoreverses = true
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    fileprivate func setupQuestionLabel() {
        let attributedString = NSMutableAttributedString(string: "What is your email?")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 100))
        questionLabel.center = CGPoint(x: self.view.frame.size.width/2, y: (self.view.frame.size.height/2) - 180)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.attributedText = attributedString
        questionLabel.font = UIFont.systemFont(ofSize: Constants.onboardingTextSize)
        questionLabel.textColor = UIColor.black
        self.view.addSubview(questionLabel)
    }
    
    fileprivate func setupExplanationLabel() {
        let attributedString = NSMutableAttributedString(string: "We will send a magic link to your email, so you can sign in instantly without remembering a password")
        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let explanationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 200))
        explanationLabel.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 - 80)
        explanationLabel.textAlignment = .center
        explanationLabel.numberOfLines = 0
        explanationLabel.attributedText = attributedString
        explanationLabel.font = UIFont.systemFont(ofSize: 18)
        explanationLabel.textColor = UIColor.black
        self.view.addSubview(explanationLabel)
    }
    
    fileprivate func setupEmailTextField() {
        emailField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constants.onboardingHorizontalPadding, height: 40))
        emailField.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 )
        emailField.textContentType = .emailAddress
        emailField.placeholder = "Email Address"
        emailField.borderStyle = UITextField.BorderStyle.roundedRect
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.layer.cornerRadius = 4.0
        emailField.layer.borderWidth = 1.0
        emailField.layer.masksToBounds = true
        self.view.addSubview(emailField)
        
        emailField.delegate = self
    }
    
    fileprivate func setupSignInButton() {
        let attributedText = NSMutableAttributedString(string: "Send Magic Link")
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedText.length))
        
        signInButton = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 80, height: 60))
        signInButton.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height - 120)
        //        signInButton.attributedText = attributedText
        signInButton.text = "Send Magic Link"
        signInButton.font = UIFont.systemFont(ofSize: 20)
        signInButton.textColor = UIColor.black
        signInButton.textAlignment = .center
        signInButton.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target:self, action: #selector(sendEmailButtonClicked))
        signInButton.addGestureRecognizer(labelTapGesture)
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.clipsToBounds = true
        self.view.addSubview(signInButton)
    }
    
    @objc func sendEmailButtonClicked(_ sender: Any) {
        signInButton.isUserInteractionEnabled = false
        emailField.endEditing(true)
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else { return }
        sendSignInLink(to: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInButton.isUserInteractionEnabled = false
        emailField.endEditing(true)
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else { return true }
        sendSignInLink(to: email)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        signInButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Firebase 🔥
    private let authorizedDomain: String = "peptalk.page.link/open"
    
    private func sendSignInLink(to email: String) {
        let actionCodeSettings = ActionCodeSettings()
        let stringURL = "https://\(authorizedDomain)?email=\(email)"
        actionCodeSettings.url = URL(string: stringURL)
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        //        actionCodeSettings.setAndroidPackageName("com.example.android",
        //                                                 installIfNotAvailable: false, minimumVersion: "12")
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            guard error == nil else {
                print(error)
                return self.displayError(error)
            }
            
//            Amplitude.instance()?.logEvent("Send Magic Link")
            UserDefaults.standard.set(email, forKey: Constants.emailKey)
            let checkEmailVC = CheckEmailViewController()
            checkEmailVC.delegate = self.delegate
            checkEmailVC.modalPresentationStyle = .fullScreen
            self.present(checkEmailVC, animated: true, completion: nil)
            
        }
    }
    
    func displayError(_ error: Error?) {
        emailField.text = ""
        emailField.placeholder = "Please enter valid email address"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.showCheckEmailSegue {
            let destinationVC = segue.destination as! CheckEmailViewController
            destinationVC.email = emailField.text
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
