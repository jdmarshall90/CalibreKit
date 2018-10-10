//
//  Image.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/9/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

public struct Image: ResponseSerializable {
    public let image: UIImage
    
    public init(from decoder: Decoder) throws {
        // TODO: revisit this, try implementing a custom Decoder and call it from ImageEndpoint.transform(responseData:), then the other init can go away
        fatalError("unused, but required by the compiler")
    }
    
    internal init(image: UIImage) {
        self.image = image
    }
}