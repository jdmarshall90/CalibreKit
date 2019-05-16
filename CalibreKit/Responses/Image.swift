//
//  Image.swift
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

import Foundation

public struct Image: ResponseSerializable {
    public let image: UIImage
    
    public init(from decoder: Decoder) throws {
        fatalError("unused, but required by the compiler")
    }
    
    public init(image: UIImage) {
        self.image = image
    }
}
