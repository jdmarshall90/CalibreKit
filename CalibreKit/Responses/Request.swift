//
//  Request.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/15/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

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
