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
    internal func responseCalibre<T: ResponseSerializable>(queue: DispatchQueue? = nil, transform: @escaping ((Data) throws -> T), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            // swiftlint:disable:next force_unwrapping
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else { return .failure(CalibreError.message("No response data")) }
            
            do {
                return .success(try transform(data))
            } catch {
                return .failure(error)
            }
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

// TODO: move this to a different spot
@discardableResult
internal func request(
    _ url: @autoclosure () throws -> URL,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil) rethrows
    -> DataRequest {
    return SessionManager.default.request(
        try url(),
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}
