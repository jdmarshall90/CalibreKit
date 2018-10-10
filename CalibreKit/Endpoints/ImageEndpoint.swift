//
//  ImageEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/9/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

public struct ImageEndpoint: Endpoint, ResponseSerializable {
    public typealias ParsedResponse = Image
    public let method: HTTPMethod = .get
    public let relativePath: String
    
    public init(from decoder: Decoder) throws {
        self.relativePath = try decoder.singleValueContainer().decode(String.self)
    }
    
    public func transform(responseData: Data) throws -> Image {
        guard let image = UIImage(data: responseData) else {
            throw CalibreError.message("Unexpected data type, non image")
        }
        return Image(image: image)
    }
}
