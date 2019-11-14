//
//  IntExtension.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation


extension Int{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
