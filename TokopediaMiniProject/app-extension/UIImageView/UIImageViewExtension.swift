//
//  UIImageViewExtension.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 08/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func setCornerRadius(cornerRadius : CGFloat = 15) {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
       }
}
