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


struct FilterShopTypeCellData {
    var goldMerchant : Int
    let isOfficial : Bool
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


class FilterShopTypeCell: UITableViewCell {
            
    private let lblTitleShopType: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 18)
             label.textColor = UIColor.black.withAlphaComponent(0.6)
             label.numberOfLines = 1
             label.translatesAutoresizingMaskIntoConstraints = false
             label.text = "Shop Type"
             return label
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
           cv.register(ShopTypeCollectionViewCell.self,
                       forCellWithReuseIdentifier: ShopTypeCollectionViewCell.shopTypeReuseIdentifier)
           cv.translatesAutoresizingMaskIntoConstraints = false
            cv.backgroundColor = .white
           return cv
       }()
    
    static let reuseIdentifier = "FilterShopTypeCell"
    private let viewModel = ShopTypeCellModel()

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
        
        NSLayoutConstraint.activate([
           lblTitleShopType.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
           lblTitleShopType.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 15),
           lblTitleShopType.heightAnchor.constraint(equalToConstant: 20),
           
           collectionView.leftAnchor.constraint(equalTo: lblTitleShopType.leftAnchor),
           collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
           collectionView.topAnchor.constraint(equalTo: lblTitleShopType.bottomAnchor, constant: 15),
           collectionView.heightAnchor.constraint(equalToConstant: 50)
           
        ])
    }
    
    func configureCell(with data: FilterShopTypeCellData) {
        print("data : \(data.isOfficial)")
        self.setupViewModel()
    }
    
    let relayData = BehaviorRelay<FilterShopTypeCellData>(value: FilterShopTypeCellData(goldMerchant: 2,isOfficial: true))
    
   
    
    let disposeBag = DisposeBag()
    
   func setupViewModel (){
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionFilterShopTypeCellData>(
              configureCell : {
             dataSource, collView , indexPath, item -> ShopTypeCollectionViewCell in
                
                if indexPath.row == 0 {
                let cell = collView.dequeueReusableCell(withReuseIdentifier: ShopTypeCollectionViewCell.shopTypeReuseIdentifier,
                   for: indexPath) as! ShopTypeCollectionViewCell
                    cell.configureCell(with: item)
                   return cell
                }else {
                    let cell = collView.dequeueReusableCell(withReuseIdentifier: ShopTypeCollectionViewCell.shopTypeReuseIdentifier,
                    for: indexPath) as! ShopTypeCollectionViewCell
                    cell.configureCell(with: item)
                    return cell
                }
              }
       )
    
    let input = ShopTypeCellModel.Input(didSetShopTypeCellData:
           relayData.asDriver()
    )
       
    let output = self.viewModel.transform(input: input)
        
    self.collectionView.rx.base.dataSource = nil
    output.shopTypeCellData.asObservable()
    .bind(to: collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
    }


}
