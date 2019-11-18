//
//  FilterShopTypeCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum FilterShopTypeState{
    case goldMerchant
    case official
}

struct FilterShopTypeCellData {
    var state : FilterShopTypeState
    var goldMerchant : Int
    var isOfficial : Bool
}

struct SectionFilterShopTypeCellData {
    var items: [Item]
}

extension SectionFilterShopTypeCellData : SectionModelType {
    typealias Item = FilterShopTypeCellData
    
    init(original: SectionFilterShopTypeCellData, items: [Item]) {
       self = original
       self.items = items
     }
}


class FilterShopTypeTVCell: UITableViewCell {
            
    private let lblTitleShopType: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 15)
             label.textColor = UIColor.black.withAlphaComponent(0.3)
             label.numberOfLines = 1
             label.translatesAutoresizingMaskIntoConstraints = false
             label.text = "Shop Type"
             return label
         }()
    
    private let btnDetailShopType: UIButton = {
                let btn = UIButton()
               btn.setTitle(">", for: .normal)
               btn.setTitleColor(.lightGray, for: .normal)
               btn.translatesAutoresizingMaskIntoConstraints = false
               return btn
            }()
    
    lazy var collectionView: UICollectionView = {
           [unowned self] in
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let size = CGSize(width:(self.frame.width/2-20), height: 250)
            layout.itemSize = size
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.register(ShopTypeCVCell.self,
                       forCellWithReuseIdentifier: ShopTypeCVCell.shopTypeReuseIdentifier)
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.backgroundColor = .white
            return cv
       }()
    
    static let reuseIdentifier = "FilterShopTypeCell"
    private let viewModel = FilterShopTypeCellVM()
    var isAbleToNavigate = true
    let relayButtonClear = BehaviorRelay<Int>(value: 0)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(lblTitleShopType)
        self.addSubview(collectionView)
        self.addSubview(btnDetailShopType)
        
        NSLayoutConstraint.activate([
           lblTitleShopType.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
           lblTitleShopType.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 15),
           lblTitleShopType.heightAnchor.constraint(equalToConstant: 20),
           
           btnDetailShopType.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
           btnDetailShopType.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -15),
           btnDetailShopType.heightAnchor.constraint(equalToConstant: 20),
           
           collectionView.leftAnchor.constraint(equalTo: lblTitleShopType.leftAnchor),
           collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
           collectionView.topAnchor.constraint(equalTo: lblTitleShopType.bottomAnchor, constant: 15),
           collectionView.heightAnchor.constraint(equalToConstant: 50)
           
        ])
    }
    
    func configureCell(with data: FilterShopTypeCellData) {
        print("data : \(data.isOfficial)")
        self.setupViewModel(data: data)
        self.isAbleToNavigate = true
    }
    
    
    let disposeBag = DisposeBag()
    
    func setupViewModel(data: FilterShopTypeCellData){
    
        let relayData = BehaviorRelay<FilterShopTypeCellData>(value: FilterShopTypeCellData(state: .goldMerchant, goldMerchant: data.goldMerchant, isOfficial: data.isOfficial))
      
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionFilterShopTypeCellData>(
              configureCell : {
             dataSource, collView , indexPath, item -> ShopTypeCVCell in
                let cell = collView.dequeueReusableCell(withReuseIdentifier: ShopTypeCVCell.shopTypeReuseIdentifier,
                   for: indexPath) as! ShopTypeCVCell
                cell.configureCell(tag:indexPath.section,data: item)
                cell.relayButton.asObservable().do(
                    onNext: {
                        value in
                        print("vaaal : \(value)")
                    }
                )
                return cell
          }
       )
    
    let input = FilterShopTypeCellVM.Input(
        didSetShopTypeCellData: relayData.asDriver(),
        navigateToShopType: self.btnDetailShopType.rx.controlEvent(.touchDown).asDriver()
    )
       
    let output = self.viewModel.transform(input: input)
        
    self.collectionView.rx.base.dataSource = nil
    
        output.shopTypeCellData.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource)
        ).disposed(by: disposeBag)
        
        
        output.navigateToShopType.drive(
               onNext: {
                  self.navigateToShopType()
            }
        ).disposed(by: disposeBag)
    
    }
    let shopTypeVC = ShopTypeVC()
    
    
    private func navigateToShopType(){
        if self.isAbleToNavigate {
            isAbleToNavigate = false
            UIApplication.topViewController()?.navigationController?.pushViewController(shopTypeVC, animated: true)
        }
    }
    
}
