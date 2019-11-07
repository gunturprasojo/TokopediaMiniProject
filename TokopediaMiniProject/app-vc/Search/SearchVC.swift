//
//  SearchVC.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: ViewController {
    
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
    
    let refreshControl = UIRefreshControl()
    
    //Model
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupViewModel()
    }
}


    //Setup
extension SearchVC {
    private func setupView() {
           title = "Search"
           view.addSubview(collectionView)
           NSLayoutConstraint.activate([
               collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
               collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
               collectionView.topAnchor.constraint(equalTo: view.topAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
           collectionView.backgroundColor = .white
    }
    
    private func setupViewModel(){
           let input = SearchViewModel.Input(didLoadTrigger: .just(()),
                                             didTapCellTrigger: collectionView.rx.itemSelected.asDriver(),
                                             pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
           
           let output = self.viewModel.transform(input: input)
           
           output.contactListCellData
               .drive(collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.reuseIdentifier, cellType: ProductListCollectionViewCell.self))
               {
               row, model, cell in
               cell.configureCell(with: model)
           }.disposed(by: self.disposeBag)
           
           output.errorData.drive(onNext:
               { errorMessage in print("") })
               .disposed(by: disposeBag)
           
           
           output.selectedIndex.drive(onNext: {
               (index, model) in
               print(model.name)
               }).disposed(by: disposeBag)
           
           output.isLoading.drive(refreshControl.rx.isRefreshing).disposed(by: disposeBag)
       
    }
}
