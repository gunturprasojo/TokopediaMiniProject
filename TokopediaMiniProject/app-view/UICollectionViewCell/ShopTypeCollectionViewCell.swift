//
//  ShopTypeCollectionViewCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources




struct ShopTypeCollectionViewCellData
{
    
}


class ShopTypeCollectionViewCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 5
        container.backgroundColor = .lightGray
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let nameLabel: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 15)
             label.textColor = UIColor.black.withAlphaComponent(0.7)
             label.numberOfLines = 1
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
    
    static let shopTypeReuseIdentifier = "ShopTypeCollectionViewCell"
    
   
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
         }
       
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    
    private func setupView() {
           self.setupNameLabel()
             
        
            contentView.addSubview(containerView)
            containerView.addSubview(nameLabel)
             
           self.setupConstraints()
         }
       
       
       private func setupNameLabel(){
            nameLabel.numberOfLines = 2
       }
       
       private func setupConstraints(){
           NSLayoutConstraint.activate([
                   containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                   containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                   containerView.heightAnchor.constraint(equalToConstant: 25 ),
                   containerView.widthAnchor.constraint(equalToConstant:  100),
                   
                   nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                   nameLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor ,constant: 0),
                   nameLabel.heightAnchor.constraint(equalToConstant: 20 ),
                   nameLabel.widthAnchor.constraint(equalToConstant:  50),
                       
                  ])
       }
    
    func configureCell(with data: FilterShopTypeCellData) {
        nameLabel.text = "\(data.goldMerchant)"
    }
    
  
   
}
