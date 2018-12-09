//
//  ImageEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/9/18.
//
//  CalibreKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  CalibreKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with CalibreKit.  If not, see <https://www.gnu.org/licenses/>.
//
//  Copyright © 2018 Justin Marshall
//  This file is part of project: CalibreKit
//

import Alamofire

public struct ImageEndpoint: Endpoint, ResponseSerializable {
    public typealias ParsedResponse = Image
    public let method: HTTPMethod = .get
    public let relativePath: String
    public let parameters: Parameters? = nil
    
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
                try request(try absoluteURL(), method: method, parameters: parameters, encoding: encoding).responseCalibre(transform: transform) { response in
                    response.result.ifSuccess {
                        // Only cache successful responses, so if it fails, it will be able to retry.
                        Cache.cache[self.relativePath] = response
                    }
                    completion(response)
                }
            } catch {
                completion(DataResponse(request: nil, response: nil, data: nil, result: .failure(error)))
            }
            
            return
        }
        completion(cachedResponse)
    }
}
