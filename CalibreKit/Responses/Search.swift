//
//  Search.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/30/18.
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
//  Copyright © 2018 Justin Marshall
//  This file is part of project: CalibreKit
//

import Foundation

public struct Search: ResponseSerializable {
    private enum CodingKeys: String, CodingKey {
        case totalBookCount = "total_num"
        case offset
        case bookIDs = "book_ids"
    }
    
    public let totalBookCount: Int
    public let offset: Int
    public let bookIDs: [BookEndpoint]
}
