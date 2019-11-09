//
//  VersionSvc.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit

class VersionSvc: NSObject {
    static func version() -> String {
        if let path = Bundle.main.path(forResource: "APIConfiguration", ofType: "plist") {
                   let dictRoot = NSDictionary(contentsOfFile: path)
                   if let dict = dictRoot {
                       return dict["version"] as! String
                   }
        }
        return ""
    }
}
