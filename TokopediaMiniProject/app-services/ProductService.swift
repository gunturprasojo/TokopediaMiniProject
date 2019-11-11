//
//  ProductService.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


enum ProductServiceError: Error {
    case serviceFetchDataFailure
    case serviceNoResponse
    case serviceTimeOut
}

protocol ProductServiceProtocol {
    func fetchProducts(url: String) -> Observable<[Product]>
}


class ProductService: ProductServiceProtocol {
    
    func fetchProducts(url: String) -> Observable<[Product]> {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let response = URLSession.shared.rx
            .data(request: urlRequest)
            .flatMapLatest { data -> Observable<ProductListResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do{
                    let resultData = try decoder.decode(ProductListResponse.self, from: data)
                    return Observable.just(resultData)
                } catch (let decodeError) {
                    return Observable.error(decodeError)
                }
        }
        let products = response.map { $0.data }
        return products
    }
}

