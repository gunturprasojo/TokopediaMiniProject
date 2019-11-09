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
    let imageURL: String
    let name: String
    let price : String
}


class ProductListCollectionViewCell: UICollectionViewCell {
     private let profileImageView = UIImageView()
    
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
          
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
          
        self.setupConstraints()
      }
    
    private func setupProfileImage(){
         profileImageView.translatesAutoresizingMaskIntoConstraints = false
         profileImageView.backgroundColor = .lightGray
        profileImageView.image = UIImage(named: "imgPlaceholder")
         profileImageView.setCornerRadius(cornerRadius: 20)
    }
    
    private func setupNameLabel(){
         nameLabel.numberOfLines = 2
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
                profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                profileImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height/3 * 2 ),
                profileImageView.widthAnchor.constraint(equalToConstant:  contentView.frame.width),
                profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                    
                 nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 10),
                 nameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 10),
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
        self.streamImage(with: data)
        priceLabel.text = data.price
      }
    
    func streamImage(with data: ProductListCollectionViewCellData){
        UIImage.streamImage(data.imageURL, completion : {
            (image, state) in
            DispatchQueue.main.async{
                if state {
                    UIView.transition(with: self.profileImageView, duration: 0.75, options: .transitionCrossDissolve, animations: {
                           self.profileImageView.image = ImageStreamManager.getImageStream(data.imageURL)
                       }, completion: nil)
                }else {
//                    self.profileImageView.image = image!
                    UIView.transition(with: self.profileImageView, duration: 0.75, options: .transitionCrossDissolve, animations: {
                      self.profileImageView.image = image!
                    }, completion: nil)
                }
            }
           
        })
    }
}
