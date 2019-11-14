//
//  FilterShopCriteriaCell.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import MultiSlider
import RxCocoa
import RxSwift
import RxDataSources

struct FilterShopCriteriaCellData {
    let maxPrice: Int
    let minPrice: Int
    let isWholeSale : Bool
}

class FilterShopCriteriaTVCell: UITableViewCell {
    
    
    private let lblTitleMinimumPrice: UILabel = {
          let label = UILabel()
          label.font = .systemFont(ofSize: 15)
          label.textColor = UIColor.black.withAlphaComponent(0.3)
          label.numberOfLines = 1
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "Minimum Value"
          return label
      }()
    
    private let lblTitleMaximumPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Maximum Value"
        return label
    }()
    
    private let lblTitleWholeSale: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Whole Sale"
        return label
    }()
    
    private let lblValueMinimumPrice : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblValueMaximumPrice : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let sliderPrice : UISlider  = {
        let slider = UISlider()
        slider.minimumValue = 100
        slider.maximumValue =  10000000
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    public var switchWholeSale : UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
       
        return sw
    }()
      
      static let reuseIdentifier = "FilterShopCriteriaCell"
    
    public var relayWholeSale = BehaviorRelay<Bool>(value: true)
    public var relayMaximumValue = BehaviorRelay<Int>(value: 10000000)
    
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          setupView()
      }
    
    private let minimumValue = 100
    private let maximumValue = 10000000
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    struct CriteriaCellInput {
           let wholeSale : Driver<Bool>
       }
    
    struct CriteriaCellOutput {
        let wholeSaleControl : Driver<Bool>
        let maximumPriceControl : Driver<Int>
    }
      
      private func setupView() {
        contentView.addSubview(lblTitleMinimumPrice)
        contentView.addSubview(lblTitleMaximumPrice)
        contentView.addSubview(lblValueMinimumPrice)
        contentView.addSubview(lblValueMaximumPrice)
        contentView.addSubview(sliderPrice)
        contentView.addSubview(lblTitleWholeSale)
        contentView.addSubview(switchWholeSale)
        
          
          NSLayoutConstraint.activate([
            lblTitleMinimumPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            lblTitleMinimumPrice.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 15),
            
            lblTitleMaximumPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            lblTitleMaximumPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -25),
            
            lblValueMinimumPrice.topAnchor.constraint(equalTo: lblTitleMinimumPrice.bottomAnchor, constant: 15),
            lblValueMinimumPrice.leadingAnchor.constraint(equalTo: lblTitleMinimumPrice.leadingAnchor),
            
            lblValueMaximumPrice.topAnchor.constraint(equalTo: lblTitleMaximumPrice.bottomAnchor, constant: 15),
            lblValueMaximumPrice.trailingAnchor.constraint(equalTo: lblTitleMaximumPrice.trailingAnchor),
            
            sliderPrice.topAnchor.constraint(equalTo: lblValueMaximumPrice.bottomAnchor, constant: 15),
            sliderPrice.leadingAnchor.constraint(equalTo: lblValueMinimumPrice.leadingAnchor),
            sliderPrice.trailingAnchor.constraint(equalTo: lblValueMaximumPrice.trailingAnchor),
            sliderPrice.heightAnchor.constraint(equalToConstant: 25),
            
            lblTitleWholeSale.topAnchor.constraint(equalTo: sliderPrice.bottomAnchor, constant: 15),
            lblTitleWholeSale.leadingAnchor.constraint(equalTo: lblValueMinimumPrice.leadingAnchor),
            
            switchWholeSale.centerYAnchor.constraint(equalTo: lblTitleWholeSale.centerYAnchor),
            switchWholeSale.trailingAnchor.constraint(equalTo: lblValueMaximumPrice.trailingAnchor)
          ])
      }
      
      func configureCell(with data: FilterShopCriteriaCellData) {
        sliderPrice.tintColor = .commonGreen
        sliderPrice.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        switchWholeSale.tintColor = .commonGreen
        switchWholeSale.isOn = data.isWholeSale
        switchWholeSale.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        lblValueMinimumPrice.text = "Rp \(self.minimumValue.formattedWithSeparator)"
        lblValueMaximumPrice.text = "Rp \(data.maxPrice.formattedWithSeparator)"
        
        sliderPrice.setValue(Float(data.maxPrice), animated: true)
        relayWholeSale.accept(data.isWholeSale)
      }

    
    @objc func sliderChanged(_ slider: UISlider) {
        let intSliderValue = Int(slider.value)
        lblValueMaximumPrice.text = "Rp \(intSliderValue.formattedWithSeparator)"
        relayMaximumValue.accept(intSliderValue)
    }
    
    
    @objc func switchValueChanged(_ sw : UISwitch){
        relayWholeSale.accept(switchWholeSale.isOn)
    }
    
    func cellOutput() -> CriteriaCellOutput {
        let wholeSaleInputTrigger = self.relayWholeSale.asDriver()
        return CriteriaCellOutput(
            wholeSaleControl: wholeSaleInputTrigger,
            maximumPriceControl: self.relayMaximumValue.asDriver()
        )
    }
}
