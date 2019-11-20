//
//  ImageStreamManager.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 08/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation
import UIKit

class ImageStreamManager {
    class func setImageStream(_ stringURL : String , value: UIImage)  {
        let data = value.jpegData(compressionQuality: 1)
        UserDefaults.standard.set(data, forKey: stringURL)
    }
    
    class func getImageStream(_ stringURL : String) -> UIImage? {
       
        let data = UserDefaults.standard.data(forKey: stringURL)
        if data != nil {
            return UIImage(data: data!, scale: 1)
        }
        return nil
    }
    
    class func removeData(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
