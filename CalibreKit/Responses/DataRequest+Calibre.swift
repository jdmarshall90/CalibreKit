//
//  DataRequest+Calibre.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
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

// modified from: https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#generic-response-object-serialization
internal extension DataRequest {
    @discardableResult
    internal func responseCalibre<T: ResponseSerializable>(queue: DispatchQueue? = nil, transform: @escaping ((Data) throws -> T), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { _, _, data, error in
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
