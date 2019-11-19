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
    lazy var collectionView: UICollectionView = {
        [unowned self] in
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let size = CGSize(width:(self.view.frame.width/2-20), height: 250)
        layout.itemSize = size
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ProductListCVCell.self,
                    forCellWithReuseIdentifier: ProductListCVCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .lightGray
        return cv
    }()
    
    
    lazy private var buttonFilter: UIButton = {
        [unowned self] in
        let btn = UIButton(frame: .zero)
        btn.setTitle("Filter", for: .normal)
        btn.titleLabel?.font =  .systemFont(ofSize: 17, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .commonGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy private var nextPageIndicator : UIActivityIndicatorView = {
        [unowned self] in
        let act = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        act.color = .commonGreen
        act.translatesAutoresizingMaskIntoConstraints = false
        return act
    }()
    
    
    
    let refreshControl = UIRefreshControl()
    
    //Model
    private let viewModel = SearchVM()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupViewModel()
        self.refreshControl.rx.base.sendActions(for: .valueChanged)
    }
    
  
}


    //Setup
extension SearchVC {
    private func setupView() {
            title = "Search"
            view.addSubview(collectionView)
            view.addSubview(buttonFilter)
            view.addSubview(nextPageIndicator)
        
            self.navigationController?.navigationBar.backItem?.title = ""
            self.navigationController?.navigationBar.tintColor = .commonGreen
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil);
            navigationItem.leftItemsSupplementBackButton = true;
        
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
        
        collectionView.accessibilityLabel = AccLabel.collectionSearchVC
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .white
    }
    
    private func setupViewModel(){
       let input = SearchVM.Input(
                        refreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver(),
                        didLoadNextDataTrigger: buttonFilter.rx.controlEvent(.touchUpInside).asDriver(),
                        navigateToFilter: buttonFilter.rx.controlEvent(.touchUpInside).asDriver(),
                        willDisplayCell: collectionView.rx.willDisplayCell.asDriver()
        )
        
        
        
       let output = self.viewModel.transform(input: input)
           
        output.productListCellData.asObservable().bind(
            to: collectionView.rx.items(cellIdentifier: ProductListCVCell.reuseIdentifier,
                                            cellType: ProductListCVCell.self))
             {
             row, model, cell in
                var tempModel = ProductListCollectionViewCellData(imageURL: model.imageURL,name: model.name , price: model.price)
                UIImage.streamImage(tempModel.imageURL, completion: {
                    image, state in
                    tempModel.img = image ?? UIImage(named: "placeholder")!
                })
                cell.configureCell(with: tempModel)
             }.disposed(by: self.disposeBag)
        
        output.errorData.drive(onNext:
               { errorMessage in print("") })
               .disposed(by: disposeBag)
           
        output.isLoading.drive(refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        
        output.isShowLoadMore.drive(
            onNext : {
                isLoadMore in
                self.isShowLoadMore(isShow: isLoadMore)
            }
        ).disposed(by: disposeBag)
        
        output.navigateToFilter.drive(
            onNext: {

            }
        ).disposed(by: disposeBag)
        
        output.loadDataFromFilter.drive(
            onNext : {
                value in
                print("loaded : \(value.valProduct)")
                self.refreshControl.rx.base.sendActions(for: .valueChanged)
            }
        ).disposed(by: disposeBag)
    }
    
    
    
    
    private func isShowLoadMore(isShow : Bool){
        if isShow {
                self.buttonFilter.setTitle("Loading Data", for: .normal)
                self.buttonFilter.setTitleColor(.commonGreen, for: .normal)
                self.buttonFilter.backgroundColor = .white
                 self.nextPageIndicator.startAnimating()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
                self.buttonFilter.setTitle("Filter", for: .normal)
                self.buttonFilter.setTitleColor(.white, for: .normal)
                self.buttonFilter.backgroundColor = .commonGreen
                self.nextPageIndicator.stopAnimating()
            })
        }
        self.buttonFilter.isEnabled = !isShow
    }
    
    func test(){
        print("test")
    }
    
}
