//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import AVFoundation

@frozen enum AuthType {
    case photoOnly
    case photoTimer
}

class HabitAuthVC: UIViewController {

    // MARK: - Properties
    
    var authType: AuthType?
    var roomID: Int?
    var restNumber: Int?
    var roomName: String?
    var presentAlertClosure: (() -> Void)?
    var restStatus: String?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var considerButton: UIButton!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var authTypeImageView: UIImageView!
    @IBOutlet weak var restNumberLabel: UILabel!
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
        setLayout()
    }
    
    @IBAction func touchOutsideDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .updateHabitRoom, object: nil)
    }
}

// MARK: Methods
extension HabitAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        switch authType {
        case .photoOnly:
            authTypeImageView.image = UIImage(named: "stickerPhotoDefault")
        case .photoTimer:
            authTypeImageView.image = UIImage(named: "stickersBoth")
        case .none:
            print("authType을 지정해주세요")
        }
        
        popUpView.layer.cornerRadius = 2
        
        okButton.layer.cornerRadius = 2
        okButton.layer.borderWidth = 1
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.tintColor = .sparkGray
        
        if restStatus == "REST" {
            okButton.isEnabled = false
            okButton.layer.borderColor = UIColor.sparkGray.cgColor
            okButton.backgroundColor = .sparkWhite
            okButton.setTitleColor(.sparkGray, for: .normal)
            okButton.setTitleColor(.sparkGray, for: .disabled)
        } else {
            okButton.isEnabled = true
            okButton.setTitleColor(.sparkWhite, for: .normal)
            okButton.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
            okButton.backgroundColor = .sparkDarkPinkred
        }

        considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        considerButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        restButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
        
        restNumberLabel.text = String(restNumber ?? 0)
        
        if (restNumber == 0) || (restStatus == "REST") {
            restButton.isEnabled = false
            restButton.layer.borderColor = UIColor.sparkGray.cgColor
            restButton.setTitleColor(.sparkGray, for: .normal)
            restButton.tintColor = .sparkGray
        }
    }
    
    private func setLayout() {
        okButton.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
    
    private func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for: .touchUpInside)
        considerButton.addTarget(self, action: #selector(touchConsiderButton), for: .touchUpInside)
        restButton.addTarget(self, action: #selector(touchRestButton), for: .touchUpInside)
    }
    
    @objc
    private func touchOkayButton() {
        let presentingVC = self.presentingViewController
        switch authType {
        case .photoOnly:
            self.dismiss(animated: true) {
                self.presentAlertClosure?()
            }
        case .photoTimer:
            self.dismiss(animated: true) {
                guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.authTimer, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authTimer) as? AuthTimerVC else { return }
                let nextVC = UINavigationController(rootViewController: rootVC)
                nextVC.modalPresentationStyle = .fullScreen
                rootVC.roomId = self.roomID
                rootVC.roomName = self.roomName
                
                presentingVC?.present(nextVC, animated: true, completion: nil)
            }
        default:
            print("아닙니다")
        }
    }
    
    @objc
    private func touchConsiderButton() {
        setConsiderRestWithAPI(statusType: "CONSIDER")
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func touchRestButton() {
        okButton.isEnabled = false
        okButton.layer.borderColor = UIColor.sparkGray.cgColor
        okButton.setTitleColor(.sparkGray, for: .normal)
        okButton.tintColor = .sparkGray
        okButton.backgroundColor = .sparkWhite
        considerButton.isEnabled = false
        considerButton.layer.borderColor = UIColor.sparkGray.cgColor
        considerButton.setTitleColor(.sparkGray, for: .normal)
        considerButton.tintColor = .sparkGray
        considerButton.backgroundColor = .sparkWhite
        setConsiderRestWithAPI(statusType: "REST")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Network

extension HabitAuthVC {
    func setConsiderRestWithAPI(statusType: String) {
        RoomAPI.shared.setConsiderRest(roomID: roomID ?? 0, statusType: statusType) {  response in
            switch response {
            case .success(let message):
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .updateHabitRoom, object: nil)
                print("setConsiderRestWithAPI - success: \(message)")
            case .requestErr(let message):
                print("setConsiderRestWithAPI - requestErr: \(message)")
            case .pathErr:
                print("setConsiderRestWithAPI - pathErr")
            case .serverErr:
                print("setConsiderRestWithAPI - serverErr")
            case .networkFail:
                print("setConsiderRestWithAPI - networkFail")
            }
        }
    }
}
