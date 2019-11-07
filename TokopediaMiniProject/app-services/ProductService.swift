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
    func reactiveFetchContacts() -> Observable<[Contact]>
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
    
    func reactiveFetchContacts() -> Observable<[Contact]> {
       let url = URL(string: "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/8935d40ae0650f12b452d6a5e9aa238a02b05511/contacts.json")!
       let urlRequest = URLRequest(url: url)
       let response = URLSession.shared.rx
           .data(request: urlRequest)
           .flatMapLatest { data -> Observable<ContactListResponse> in
               let decoder = JSONDecoder()
               decoder.keyDecodingStrategy = .convertFromSnakeCase
               do{
                   let resultData = try decoder.decode(ContactListResponse.self, from: data)
                   return Observable.just(resultData)
               } catch (let decodeError) {
                   return Observable.error(decodeError)
               }
       }
       let contacts = response.map { $0.data }
       return contacts
   }
}


struct Contact: Decodable {
    let id: Int
    let name: String
    let phoneNumber: String
    let email: String
    let imageUrl: String
}

struct ContactListResponse: Decodable {
    let data: [Contact]
}
