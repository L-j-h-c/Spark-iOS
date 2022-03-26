//
//  WithdrawalVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/25.
//

import UIKit

class WithdrawalVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var customNavigationBar: LeftButtonNavigaitonBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topDividerLine: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var firstCircleLabel: UILabel!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondCircleLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var bottomDividerLine: UIView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var withdrawalLabel: UILabel!
    @IBOutlet weak var withdrawalButton: BottomButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddTargets()
    }
}

// MARK: - Extension

extension WithdrawalVC {
    private func setUI() {
        customNavigationBar.title("회원 탈퇴")
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.navigationController?.popViewController(animated: true)
            }
        
        titleLabel.font = .h3Subtitle
        titleLabel.textColor = .sparkBlack
        titleLabel.text = "회원 탈퇴 유의사항"
        
        topDividerLine.backgroundColor = .sparkDarkGray
        
        subtitleLabel.font = .p1TitleLight
        subtitleLabel.textColor = .sparkDarkGray
        subtitleLabel.text = "회원 탈퇴 시,"
        
        firstTextLabel.font = .p1TitleLight
        firstTextLabel.textColor = .sparkDarkGray
        firstTextLabel.text = "진행 중인 모든 습관방에서 나가지며, 그동안의 습관 기록들은 전부 삭제되어 복구 불가능합니다."
        firstTextLabel.numberOfLines = 0
        firstTextLabel.lineBreakMode = .byCharWrapping
        
        firstCircleLabel.font = .p1TitleLight
        firstCircleLabel.text = "   •"
        firstCircleLabel.textColor = .sparkDarkGray
        
        secondTextLabel.font = .p1TitleLight
        secondTextLabel.textColor = .sparkDarkGray
        secondTextLabel.text = "최근 7일 동안의 습관 인증, 친구에게 보낸 스파크, 좋아요 등 타 스파커들에게 공유된 정보는 각가의 습관방에 귀속되어, 생성일로부터 7일 동안 보관 후 삭제됩니다."
        secondTextLabel.numberOfLines = 0
        secondTextLabel.lineBreakMode = .byCharWrapping
        
        secondCircleLabel.font = .p1TitleLight
        secondCircleLabel.text = "   •"
        secondCircleLabel.textColor = .sparkDarkGray
        
        bottomDividerLine.backgroundColor = .sparkDarkGray
        
        checkboxButton.setImage(UIImage(named: "btnCheckBoxDefault"), for: .normal)
        checkboxButton.setImage(UIImage(named: "btnCheckBox"), for: .selected)
        
        withdrawalLabel.font = .p2Subtitle
        withdrawalLabel.textColor = .sparkDarkGray
        withdrawalLabel.text = "위의 사항을 숙지하였으며, 이에 동의합니다."
        
        withdrawalButton.setTitle("탈퇴하기")
            .setUI(.pink)
            .setDisable()
    }
    
    private func setAddTargets() {
        withdrawalButton.addTarget(self, action: #selector(touchWithdrawalButtonButton), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(touchCheckboxButton), for: .touchUpInside)
    }

    // MARK: - @Objc Methods
    
    @objc
    private func touchWithdrawalButtonButton() {
        // TODO: - 탈퇴하기 서버통신
    }
    
    @objc
    private func touchCheckboxButton() {
        if checkboxButton.isSelected {
            checkboxButton.isSelected = false
            withdrawalButton.setDisable()
        } else {
            checkboxButton.isSelected = true
            withdrawalButton.setAble()
        }
    }
}
