//
//  UIImageExtension.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 08/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    static func streamImage(_ withUrlString : String , completion: @escaping ((UIImage?, Bool) -> Void)){
        let placeholder = UIImage(named: "imgPlaceholder")
        completion(placeholder,false)
        
        if let stream = ImageStreamManager.getImageStream(withUrlString){
            completion(stream,true)
        }else {
                getData(from: URL(string: withUrlString)!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    if let imgData = UIImage(data: data) {
                    ImageStreamManager.setImageStream(withUrlString, value: imgData)
                    completion(imgData,true)
                    }
                }
        }
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
