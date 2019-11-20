//
//  FormatterStyle.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit

class FormatterStyle: NSObject {
    static func separatorNumberStyle() -> String {
        if let path = Bundle.main.path(forResource: "APPConfiguration", ofType: "plist") {
                   let dictRoot = NSDictionary(contentsOfFile: path)
                   if let dict = dictRoot {
                       return dict["currencySeparatorStyle"] as! String
                   }
        }
        return ""
    }
}
