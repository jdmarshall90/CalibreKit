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
    
    internal struct Cache {
        // Long term, this caching will likely need to be ripped out and made scalable.
        // Good enough for now, though.
        private init() {}
        
        internal static var cache: [String: DataResponse<Image>] = [:]
    }
    
    public init(from decoder: Decoder) throws {
        self.relativePath = try decoder.singleValueContainer().decode(String.self)
    }
    
    public func transform(responseData: Data) throws -> Image {
        guard let image = UIImage(data: responseData) else {
            throw CalibreError.message("Unexpected data type, non image")
        }
        return Image(image: image)
    }
    
    public func hitService(completion: @escaping (DataResponse<Image>) -> Void) {
        guard let cachedResponse = Cache.cache[relativePath] else {
            do {
                try request(try absoluteURL(), method: method, parameters: nil).responseCalibre(transform: transform) {
                    Cache.cache[self.relativePath] = $0
                    completion($0)
                }
            } catch {
                completion(DataResponse(request: nil, response: nil, data: nil, result: .failure(error)))
            }
            
            return
        }
        completion(cachedResponse)
    }
}
