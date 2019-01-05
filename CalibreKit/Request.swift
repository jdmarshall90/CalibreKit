//
//  Request.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/15/18.
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
import Foundation

@discardableResult
internal func request(
    _ url: @autoclosure () throws -> URL,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil) rethrows
    -> DataRequest {
        let theRequest = SessionManager.default.request(
            try url(),
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        
        if let credentials = CalibreKitConfiguration.configuration?.credentials {
            theRequest.authenticate(usingCredential: URLCredential(user: credentials.username, password: credentials.password, persistence: .forSession))
        }
        return theRequest
}
