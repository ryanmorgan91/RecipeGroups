//
//  ImageWrapper.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 6/23/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit


// A wrapper class to conform UIImage to the Codable protocol
class Image: Codable {
    
    var uiImage: UIImage?
    
    init(image: UIImage? = nil) {
        self.uiImage = image
    }
    
    enum CodingKeys: String, CodingKey {
        case image = "uiImage"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let imageData = try? container.decode(Data.self, forKey: CodingKeys.image),
            let image = UIImage(data: imageData) {
                self.uiImage = image
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let image = uiImage {
            let encodedImage = image.jpegData(compressionQuality: 1.0)
            try container.encode(encodedImage, forKey: .image)
        }
    }
}
