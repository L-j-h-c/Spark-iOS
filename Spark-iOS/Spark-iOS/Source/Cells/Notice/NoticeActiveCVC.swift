//
//  NoticeActiveCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/08.
//

import UIKit

import SnapKit

class NoticeActiveCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentImageView = UIImageView()
    private let bottomLineView = UIView()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        contentLabel.text = ""
        dateLabel.text = ""
        contentImageView.image = UIImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        contentLabel.preferredMaxLayoutWidth = contentLabel.frame.size.width
    }
    
    // MARK: - Method
    
    private func setUI() {
        titleLabel.font = .p1Title
        contentLabel.font = .p2Subtitle
        dateLabel.font = .caption
        
        titleLabel.textColor = .sparkBlack
        contentLabel.textColor = .sparkDeepGray
        dateLabel.textColor = .sparkDarkGray
        
        titleLabel.numberOfLines = 2
        contentLabel.numberOfLines = 2
        
        contentImageView.layer.borderWidth = 2
        contentImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        contentImageView.layer.masksToBounds = true
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.backgroundColor = .sparkDarkGray
        
        bottomLineView.backgroundColor = .sparkGray.withAlphaComponent(0.3)
    }
    
    func initCell(title: String, content: String, date: String, image: String) {
        // TODO: - 사진 종류에 따라 radius 적용
        titleLabel.text = title
        contentLabel.text = content
        dateLabel.text = date
        contentImageView.updateImage(image, type: .small)
    }
}

// MARK: - Layout

extension NoticeActiveCVC {
    private func setLayout() {
        self.addSubviews([titleLabel, contentLabel, dateLabel,
                          contentImageView, bottomLineView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(contentImageView.snp.leading).offset(-28)
            make.top.equalToSuperview().inset(22)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(22)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(44)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
