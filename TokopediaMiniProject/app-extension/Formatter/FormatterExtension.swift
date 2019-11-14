//
//  FormatterExtension.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = FormatterStyle.separatorNumberStyle()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
