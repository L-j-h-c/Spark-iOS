//
//  LoginVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/12.
//

import AuthenticationServices
import UIKit

import KakaoSDKUser

class LoginVC: UIViewController {

    // MARK: - Properties
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - @IBOutlet Action
    
    @IBAction func touchAppleLoginButton(_ sender: Any) {
        signupWithApple()
    }
    
    @IBAction func touchKakaoLoginButton(_ sender: Any) {
        signupWithKakao()
    }
}

// MARK: - Methods

extension LoginVC {
    private func setUI() {
        loginLabel.text = "로그인 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        loginLabel.textColor = .sparkWhite
        
        loginLabel.font = .krMediumFont(ofSize: 12)
        
        kakaoLoginButton.setImage(UIImage(named: "btnKakaoLogin"), for: .normal)
        appleLoginButton.setImage(UIImage(named: "btnAppleLogin"), for: .normal)
    }
    
    private func signupWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func signupWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoApp()
        } else {
            loginWithWeb()
        }
    }
    
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { _, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoApp() success.")
                
                self.getUserID()
            }
        }
    }
    
    private func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount { _, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                self.getUserID()
            }
        }
    }
    
    private func getUserID() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                if let userID = user?.id {
                    UserDefaults.standard.set(String(userID), forKey: Const.UserDefaultsKey.userID)
                    UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isAppleLogin)
                    
                    self.loginWithAPI(userID: String(userID))
                }
            }
        }
    }
    
    private func presentToMainTabBar() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - AppleSignIn

extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            
            UserDefaults.standard.set(userIdentifier, forKey: Const.UserDefaultsKey.userID)
            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.isAppleLogin)
            
            loginWithAPI(userID: userIdentifier)
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

// MARK: - Network

extension LoginVC {
    private func loginWithAPI(userID: String) {
        AuthAPI.shared.login(socialID: userID, fcmToken: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.fcmToken) ?? "") { response in
            switch response {
            case .success(let data):
                if let message = data as? String {
                    if message == "회원가입을 하지 않은 사용자입니다" {
                        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.profileSetting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.profileSetting) as? ProfileSettingVC else { return }
                        
                        nextVC.modalPresentationStyle = .fullScreen
                        
                        self.present(nextVC, animated: true, completion: nil)
                    } else {
                        // 회원 정보를 불러왔습니다
                        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
                        
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.modalTransitionStyle = .crossDissolve
                        
                        self.present(nextVC, animated: true, completion: nil)
                    }
                }
            case .requestErr(let message):
                print("habitRoomFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("habitRoomFetchWithAPI - pathErr")
            case .serverErr:
                print("habitRoomFetchWithAPI - serverErr")
            case .networkFail:
                print("habitRoomFetchWithAPI - networkFail")
            }
        }
    }
}
