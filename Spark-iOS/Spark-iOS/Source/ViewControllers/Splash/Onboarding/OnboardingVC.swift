//
//  OnboardingVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/12.
//

import UIKit

import SnapKit

class OnboardingVC: UIViewController {
    
    // MARK: Properties
    
    private var sparkStartButtonHidden: Bool = false {
        didSet {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? OnboardingCVC else { return }
            if sparkStartButtonHidden == false {
                cell.sparkStartButton.isHidden = false
                cell.sparkStartButton.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    cell.sparkStartButton.alpha = 1
                }
            } else {
                cell.sparkStartButton.isHidden = true
            }
        }
    }
    
    private var currentPage: Int = 0 {
         didSet {
             pageControl.currentPage = currentPage
             if currentPage == 3 {
                 skipButton.isHidden = true
             } else {
                 skipButton.isHidden = false
             }
         }
    }
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.sparkGray, for: .normal)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = .h3Subtitle
//        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = .zero
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .sparkGray
        iv.image = UIImage(named: "bgOnboarding")
        return iv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 4
        pc.pageIndicatorTintColor = .sparkLightGray
        pc.currentPageIndicatorTintColor = .sparkLightPinkred
        return pc
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setCollectionView()
        setDelegate()
    }
    
    // MARK: Methods
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setCollectionView() {
        collectionView.register(OnboardingCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.onboardingCVC)
    }
}

extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.onboardingCVC, for: indexPath) as? OnboardingCVC else { return UICollectionViewCell()
        }
        cell.viewModel = OnboardingCVCViewModel(index: indexPath.row)
        return cell
    }
}

extension OnboardingVC: UICollectionViewDelegate {
    // 스크롤이 애니메이션이 끝나기 전에 목표지를 예상해주는 메서드 - 페이지컨트롤의 자연스러운 전환을 위해 사용
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.currentPage = page
    }
    
    // 스크롤이 시작되면 호출되는 메서드 - 버튼이 바로 사라지도록 하기 위해 사용
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !sparkStartButtonHidden {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? OnboardingCVC else { return }
            UIView.animate(withDuration: 0.05) {
                cell.sparkStartButton.alpha = 0
            }
        }
    }
    
    // 스크롤 애니메이션이 끝나면 호출되는 메서드 - 완전히 끝에 도달한 뒤에 버튼을 나타내기 위해서 사용
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x + 1) >= (scrollView.contentSize.width - scrollView.frame.size.width) {
            sparkStartButtonHidden = false
        } else {
            sparkStartButtonHidden = true
        }
    }
}

extension OnboardingVC {
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setLayout() {
        view.addSubviews([backgroundImageView, collectionView, pageControl, skipButton])
        
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(61)
            make.leading.equalToSuperview().offset(20)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(108)
        }
    }
}
