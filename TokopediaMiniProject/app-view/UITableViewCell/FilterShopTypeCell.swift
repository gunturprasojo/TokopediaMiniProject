//
//  FilterShopTypeCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit


struct FilterShopTypeCellData {
    let goldMerchant : Int
    let isOfficial : Bool
}

class FilterShopTypeCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
            private let nameLabel: UILabel = {
                let label = UILabel()
                label.font = .systemFont(ofSize: 15)
                label.textColor = UIColor.black.withAlphaComponent(0.7)
                label.numberOfLines = 1
                label.translatesAutoresizingMaskIntoConstraints = false
                
                return label
            }()
            
            static let reuseIdentifier = "FilterShopTypeCell"

            override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: style, reuseIdentifier: reuseIdentifier)
                setupView()
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private func setupView() {
                profileImageView.translatesAutoresizingMaskIntoConstraints = false
                profileImageView.layer.cornerRadius = 32
                profileImageView.backgroundColor = .lightGray
                
                contentView.addSubview(profileImageView)
                contentView.addSubview(nameLabel)
                
                NSLayoutConstraint.activate([
                    profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    profileImageView.heightAnchor.constraint(equalToConstant: 64),
                    profileImageView.widthAnchor.constraint(equalToConstant: 64),
                    profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
                    nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16),
                    nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
                    nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                    nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
                ])
            }
            
            func configureCell(with data: FilterShopTypeCellData) {
              nameLabel.text = "\(data.goldMerchant)"
            }


}
