//
//  BookDownloadEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 3/1/19.
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
//  along with Libreca.  If not, see <https://www.gnu.org/licenses/>.
//
//  Copyright © 2019 Justin Marshall
//  This file is part of project: CalibreKit
//

import Alamofire

public struct BookDownloadEndpoint: Endpoint {
    public typealias ParsedResponse = BookDownload
    public let method: HTTPMethod = .get
    public let relativePath: String
    public let parameters: Parameters? = nil
    
    public let format: Book.Format
    
    public func transform(responseData: Data) throws -> BookDownload {
        return BookDownload(format: format, file: responseData)
    }
}
