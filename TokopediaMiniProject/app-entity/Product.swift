//
//  Product.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation

struct Product : Decodable {
    let id : Int
    let name: String
    let imageUri: String
    let price : String
}

struct ProductListResponse : Decodable {
    let data : [Product]
}


