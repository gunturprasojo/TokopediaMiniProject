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


class ShopTypeCVCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 45/2
        container.backgroundColor = .white
        container.layer.borderWidth = 3
        container.layer.borderColor = CGColor.init(srgbRed: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let nameLabel: UILabel = {
             let label = UILabel()
             label.font = .systemFont(ofSize: 12)
            label.textColor = .darkGray//UIColor.black.withAlphaComponent(0.7)
             label.numberOfLines = 1
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
    }()
    
    private let clearButton: UIButton = {
            let btn = UIButton()
            btn.setTitle("x", for: .normal)
            btn.setTitleColor(.lightGray, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.layer.borderWidth = 2
            btn.layer.cornerRadius = 45/2
            btn.layer.borderColor = CGColor.init(srgbRed: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            return btn
    }()
    
    static let shopTypeReuseIdentifier = "ShopTypeCollectionViewCell"
    

   let relayButton = BehaviorRelay<Int>(value: 0)
   @objc func actClear(_ btn : UIButton){
    print("tag : \(btn.tag)")
       relayButton.accept(btn.tag)
   }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
         }
       
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupView() {
        self.setupNameLabel()
        clearButton.addTarget(self, action: #selector(actClear(_:)), for: .touchUpInside)
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(clearButton)
        self.setupConstraints()
    }
       
       
       private func setupNameLabel(){
            nameLabel.numberOfLines = 2
       }
       
       private func setupConstraints(){
           NSLayoutConstraint.activate([
                   containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                   containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                   containerView.heightAnchor.constraint(equalToConstant: 45),
                   containerView.widthAnchor.constraint(equalToConstant:  150),
                   
                   nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                   nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor ,constant: 15),
                   nameLabel.heightAnchor.constraint(equalToConstant: 45),
                   nameLabel.widthAnchor.constraint(equalToConstant:  150),
                   
                   clearButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                   clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                   clearButton.heightAnchor.constraint(equalToConstant: 45),
                   clearButton.widthAnchor.constraint(equalToConstant:  45)
                       
                  ])
       }
    
    func configureCell(tag : Int,data: FilterShopTypeCellData) {
       clearButton.tag = tag
        switch data.state {
        case .goldMerchant :
            nameLabel.text = "Gold Merchant"
            break
        case .official :
            nameLabel.text = "Official Store"
            break
        }
        
    }
    
  
   
}
