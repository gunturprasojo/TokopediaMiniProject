//
//  ProductListCollectionViewCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct ProductListCollectionViewCellData {
    var imageURL : String
    let name: String
    let price : String
    var img : UIImage = UIImage(named: "imgPlaceholder")!

}


class ProductListCollectionViewCell: UICollectionViewCell {
    
    private let productImageVIew = UIImageView(image: UIImage(named: "imgPlaceholder"))
    
    private let nameLabel: UILabel = {
          let label = UILabel()
          label.font = .systemFont(ofSize: 15)
          label.textColor = UIColor.black.withAlphaComponent(0.7)
          label.numberOfLines = 1
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor.orange.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
      
    static let reuseIdentifier = "ProductListCollectionViewCell"

    private let animationTransition : UIView.AnimationOptions = .curveEaseIn
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
    
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      private func setupView() {
        self.setupProfileImage()
        self.setupNameLabel()
          
        contentView.addSubview(productImageVIew)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
          
        self.setupConstraints()
      }
    
    private func setupProfileImage(){
         productImageVIew.translatesAutoresizingMaskIntoConstraints = false
         productImageVIew.backgroundColor = .lightGray
         productImageVIew.setCornerRadius(cornerRadius: 20)
    }
    
    private func setupNameLabel(){
         nameLabel.numberOfLines = 2
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
                productImageVIew.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                productImageVIew.heightAnchor.constraint(equalToConstant: contentView.frame.height/3 * 2 ),
                productImageVIew.widthAnchor.constraint(equalToConstant:  contentView.frame.width),
                productImageVIew.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                    
                 nameLabel.topAnchor.constraint(equalTo: productImageVIew.bottomAnchor , constant: 10),
                 nameLabel.leftAnchor.constraint(equalTo: productImageVIew.leftAnchor, constant: 10),
                 nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
                 nameLabel.heightAnchor.constraint(equalToConstant: 45),
            
                priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor , constant: 10),
                priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
                priceLabel.heightAnchor.constraint(equalToConstant: 15)
               ])
    }
      
      func configureCell(with data: ProductListCollectionViewCellData) {
        nameLabel.text = data.name
        productImageVIew.image = data.img
        priceLabel.text = data.price
      }
    
}
