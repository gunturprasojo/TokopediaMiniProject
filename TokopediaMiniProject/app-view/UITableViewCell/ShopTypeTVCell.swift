//
//  ShopTypeTVCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 18/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit

class ShopTypeTVCell: UITableViewCell {

    private let lblTitleShopType: UILabel = {
                let label = UILabel()
                label.font = .systemFont(ofSize: 15)
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.numberOfLines = 1
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Gold Merchant"
                return label
        }()
       
       private let btnDetailShopType: UIButton = {
               let btn = UIButton()
                btn.setImage(SearchConstant.checkBoxChecked!, for: .normal)
              btn.setTitleColor(.lightGray, for: .normal)
              btn.translatesAutoresizingMaskIntoConstraints = false
              return btn
       }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static let reuseIdentifier = "ShopTypeTVCell"
    
    public var callbackTag : ((Int)->())?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    @objc func actButton(_ sender : UIButton){
        let lblTitle = self.lblTitleShopType.text ?? "Gold Merchant"
               if lblTitle.lowercased() == "gold merchant"{
                   self.callbackTag?(0)
               }else {
                    self.callbackTag?(1)
               }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
           self.addSubview(lblTitleShopType)
           self.addSubview(btnDetailShopType)
           btnDetailShopType.addTarget(self, action: #selector(actButton(_:)), for: .touchUpInside)
           NSLayoutConstraint.activate([
              
            btnDetailShopType.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:0),
            btnDetailShopType.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 15),
            btnDetailShopType.heightAnchor.constraint(equalToConstant: 20),
            btnDetailShopType.widthAnchor.constraint(equalToConstant: 20),
                
            lblTitleShopType.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            lblTitleShopType.leadingAnchor.constraint(equalTo: self.btnDetailShopType.trailingAnchor , constant: 10),
            lblTitleShopType.heightAnchor.constraint(equalToConstant: 15)
           ])
    }
    
    func configureCell(with data: FilterShopTypeCellData) {
           print("data : \(data.isOfficial)")
            switch data.state {
            case .goldMerchant:
                self.lblTitleShopType.text = "Gold Merchant"
                if data.goldMerchant == SearchConstant.goldMerchant {
                    btnDetailShopType.setImage(SearchConstant.checkBoxChecked!, for: .normal)
                }else {
                    btnDetailShopType.setImage(SearchConstant.checkBoxUnchecked!, for: .normal)
                }
                break
            case .official :
                self.lblTitleShopType.text = "Official"
                
                if data.isOfficial {
                    btnDetailShopType.setImage(SearchConstant.checkBoxChecked!, for: .normal)
                }else {
                     btnDetailShopType.setImage(SearchConstant.checkBoxUnchecked!, for: .normal)
                }
                break
            }
       }
    

}
