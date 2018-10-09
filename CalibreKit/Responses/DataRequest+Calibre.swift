//
//  DataRequest+Calibre.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

// modified from: https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#generic-response-object-serialization
internal extension DataRequest {
    @discardableResult
    internal func responseCalibre<T: ResponseObjectSerializable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            // swiftlint:disable:next force_unwrapping
            guard error == nil else { return .failure(error!) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            switch result {
            case .success(let rawJSON):
                do {
                    guard let json = rawJSON as? [String: [String: Any]] else {
                        return .failure(CalibreError.message("Unexpected response type: \(type(of: rawJSON))"))
                    }
                    
                    let responseObject = try T(representation: json)
                    return .success(responseObject)
                } catch {
                    return .failure(CalibreError.message("JSON could not be serialized: \(error)"))
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
