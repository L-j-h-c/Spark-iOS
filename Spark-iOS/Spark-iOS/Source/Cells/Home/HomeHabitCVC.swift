//
//  HomeHabitCVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import UIKit

class HomeHabitCVC: UICollectionViewCell {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var flakeImage: UIImageView!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var ddayTitleLabel: UILabel!
    @IBOutlet weak var ddaySubtitleLabel: UILabel!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var tagDoneImage: UIImageView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var firstProfileImage: UIImageView!
    @IBOutlet weak var secondProfileImage: UIImageView!
    @IBOutlet weak var thirdProfileImage: UIImageView!
    @IBOutlet weak var fourthProfileImage: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    @IBOutlet weak var thirdLifeImage: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    override func prepareForReuse() {
        flakeImage.image = UIImage()
        ticketImage.image = UIImage()
        restLabel.text = ""
        restLabel.isHidden = true
        ddayTitleLabel.text = ""
        ddaySubtitleLabel.text = ""
        fourthProfileImage.isHidden = true
        
        habitTitleLabel.text = ""
        tagDoneImage.isHidden = true
        memberLabel.text = ""
        
        [firstLifeImage, secondLifeImage, thirdLifeImage].forEach {
            $0?.image = UIImage()
        }
        
        [firstProfileImage, secondProfileImage, thirdProfileImage, fourthProfileImage].forEach {
            $0?.image = UIImage()
            $0?.isHidden = true
        }
    }
}

// MARK: - Methods

extension HomeHabitCVC {
    private func setUI() {
        flakeImage.contentMode = .scaleAspectFill
        ticketImage.contentMode = .scaleAspectFit
        
        ddayTitleLabel.font = .h1Bigtitle
        ddaySubtitleLabel.font = .caption
        
        [firstProfileImage, secondProfileImage, thirdProfileImage, fourthProfileImage].forEach {
            $0?.layer.cornerRadius = 13
            $0?.layer.borderWidth = 2
            $0?.layer.borderColor = UIColor.sparkWhite.cgColor
            $0?.contentMode = .scaleToFill
        }
        
        restLabel.font = .enMediumFont(ofSize: 10)
        restLabel.textColor = .sparkWhite
        
        habitTitleLabel.font = .h2Title
        habitTitleLabel.textColor = .sparkDeepGray
        habitTitleLabel.numberOfLines = 2
        habitTitleLabel.lineBreakMode = .byTruncatingTail
        
        tagDoneImage.isHidden = true
        
        memberLabel.textColor = .sparkDeepGray
    }
    
    /// 셀 초기화
    func initCell(roomName: String,
                  leftDay: Int,
                  profileImg: [String?],
                  life: Int,
                  isDone: Bool,
                  memberNum: Int,
                  doneMemberNum: Int) {
        if leftDay == 0 {
            ddayTitleLabel.text = "D-day"
        } else {
            ddayTitleLabel.text = "D-\(leftDay)"
        }
        
        // 프로필 이미지 구현
        let profileImageList = [firstProfileImage, secondProfileImage, thirdProfileImage]
        
        if memberNum > 3 {
            for index in 0..<3 {
                profileImageList[index]?.updateImage(profileImg[index] ?? "")
                profileImageList[index]?.isHidden = false
            }
            
            fourthProfileImage.isHidden = false
            restLabel.isHidden = false
            restLabel.text = "+\(memberNum - 3)"
        } else {
            if memberNum == 3 {
                for index in 0..<3 {
                    profileImageList[index]?.updateImage(profileImg[index] ?? "")
                    profileImageList[index]?.isHidden = false
                }
            } else {
                for index in 0..<memberNum {
                    profileImageList[index]?.updateImage(profileImg[index] ?? "")
                    profileImageList[index]?.isHidden = false
                    
                    fourthProfileImage.isHidden = true
                    restLabel.isHidden = true
                }
                for index in memberNum...2 {
                    profileImageList[index]?.isHidden = true
                }
            }
            
            fourthProfileImage.isHidden = true
            restLabel.isHidden = true
        }
        
        habitTitleLabel.text = roomName
        
        // 방 생명 이미지 구현
        let lifeImgaeList = [firstLifeImage, secondLifeImage, thirdLifeImage]
        
        if life >= 3 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeFullBlack")}
        } else if life == 0 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeEmpty")}
        } else {
            for index in 0..<life {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeFullBlack")
            }
            for index in life...2 {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeEmpty")
            }
        }
        
        if isDone {
            ticketImage.image = UIImage(named: "property1TicketRightFold4")
            tagDoneImage.isHidden = false
            
        } else {
            ticketImage.image = UIImage(named: "property1TicketRight4")
            tagDoneImage.isHidden = true
        }
        
        // spark flake
        let sparkFlake: SparkFlake =  SparkFlake(leftDay: leftDay)
        
        ddayTitleLabel.textColor = sparkFlake.sparkFlakeColor()
        ddaySubtitleLabel.text = sparkFlake.sparkFlakeMent()
        ddaySubtitleLabel.textColor = sparkFlake.sparkFlakeColor()
        
        flakeImage.image = sparkFlake.sparkFlakeTicketImage()
        
        let attributedString = NSMutableAttributedString(string: "\(doneMemberNum)/\(memberNum)명")
        attributedString.addAttribute(.foregroundColor, value: sparkFlake.sparkFlakeColor(), range: NSRange(location: 0, length: "\(doneMemberNum)".count))
        memberLabel.attributedText = attributedString
    }
}
