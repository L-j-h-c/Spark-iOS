//
//  StorageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class StorageVC: UIViewController {
    var DoingCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 197,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .red
        
        return name
    }()
    
    var DoneCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 200,y: 400,width: 200,height: 200), collectionViewLayout: layout)
        name.backgroundColor = .blue
        
        return name
    }()
    
    var FailCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 200,y: 600,width: 200,height: 200), collectionViewLayout: layout)
        name.backgroundColor = .purple
        
        return name
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setCarousels()
        addSubviews(firstViewButton, secondViewButton, thirdViewButton, DoingCV, DoneCV, FailCV)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setDelegate() {
        DoingCV.delegate = self
        DoingCV.dataSource = self
        DoneCV.delegate = self
        DoneCV.dataSource = self
        FailCV.delegate = self
        FailCV.dataSource = self
        DoneCV.isHidden = true
        FailCV.isHidden = true
    }
extension StorageVC {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.view.addSubview(view)
        }
    }
    
    func setCarousels() {
        setCarouselLayout(collectionView: DoingCV)
        setCarouselLayout(collectionView: DoneCV)
        setCarouselLayout(collectionView: FailCV)
    }
    
    // TODO: 하나 레이아웃 다 잡고 레지스터 부분 밖으로 빼주자
    // 컬렉션뷰의 레이아웃을 캐러셀 형식으로 변환시키는 함수
    func setCarouselLayout(collectionView: UICollectionView) {
        let layout = CarouselLayout()
        
        let centerItemWidthScale: CGFloat = 327/375
        let centerItemHeightScale: CGFloat = 1
        
        layout.itemSize = CGSize(width: collectionView.frame.width*centerItemWidthScale, height: collectionView.frame.height*centerItemHeightScale)

        layout.sideItemScale = 464/520
        layout.spacing = 12
        layout.sideItemAlpha = 0.4
        
        collectionView.collectionViewLayout = layout
        
        let xibCollectionViewName = UINib(nibName: "DoingStorageCVC", bundle: nil)
        collectionView.register(xibCollectionViewName, forCellWithReuseIdentifier: "DoingStorageCVC")
        collectionView.reloadData()
    }
}

extension StorageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoingStorageCVC", for: indexPath) as! DoingStorageCVC

         return cell
     }

        // Do any additional setup after loading the view.
    }
}
