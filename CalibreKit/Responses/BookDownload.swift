//
//  BookDownload.swift
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

import Foundation

public struct BookDownload: ResponseSerializable, Encodable {
    private enum CodingKeys: String, CodingKey {
        case file
        case format
    }
    
    public let file: Data
    public let format: Book.Format
    
    internal init(format: Book.Format, file: Data) {
        self.format = format
        self.file = file
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.file = try container.decode(Data.self, forKey: .file)
        self.format = try container.decode(Book.Format.self, forKey: .format)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file, forKey: .file)
        try container.encode(format, forKey: .format)
    }
}
