//
//  FilterVC.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    //Outlet
    lazy private var collectionView: UICollectionView = {
        [unowned self] in
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let size = CGSize(width:(self.view.frame.width/2-20), height: 250)
        layout.itemSize = size
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ProductListCollectionViewCell.self,
                    forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .lightGray
        return cv
    }()
    
    let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popThisVC))
    
    lazy private var buttonFilter: UIButton = {
        [unowned self] in
        let btn = UIButton(frame: .zero)
        btn.setTitle("Apply", for: .normal)
        btn.titleLabel?.font =  .systemFont(ofSize: 17, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .commonGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(popThisVC), for: .touchDown)
        return btn
    }()
    
    lazy private var nextPageIndicator : UIActivityIndicatorView = {
        [unowned self] in
        let act = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        act.color = .commonGreen
        act.translatesAutoresizingMaskIntoConstraints = false
        return act
    }()
    
    var servicePayload = SearchViewModelData()
    var callbackPayload : ((SearchViewModelData)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        
        print(servicePayload.currentPageInquiry)
    }
    
    @objc func popThisVC(){
        if servicePayload.valProduct == "apple" {
            servicePayload.valProduct = "samsung"
        }else {
            servicePayload.valProduct = "apple"
        }
        
        self.callbackPayload?(self.servicePayload)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
            backButton.tintColor = UIColor.white
            title = "Filter"
            self.navigationController?.navigationBar.tintColor = .black
        
        
            view.addSubview(collectionView)
            view.addSubview(buttonFilter)
            view.addSubview(nextPageIndicator)
        
           NSLayoutConstraint.activate([
               collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
               collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
               collectionView.topAnchor.constraint(equalTo: view.topAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                      constant: -(self.view.frame.height * 0.1)),
               
               buttonFilter.leftAnchor.constraint(equalTo: view.leftAnchor),
               buttonFilter.rightAnchor.constraint(equalTo: view.rightAnchor),
               buttonFilter.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
               buttonFilter.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               
               nextPageIndicator.centerXAnchor.constraint(equalTo: buttonFilter.centerXAnchor, constant: -75),
               nextPageIndicator.centerYAnchor.constraint(equalTo: buttonFilter.centerYAnchor, constant: 1),
               nextPageIndicator.heightAnchor.constraint(equalToConstant: 35)
               
               
           ])
        collectionView.backgroundColor = .darkGray
    }
    


}
