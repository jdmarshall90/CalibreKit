//
//  CalibreKitConfiguration.swift
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

import AlamofireNetworkActivityIndicator
import Foundation

public struct CalibreKitConfiguration {
    @available(*, deprecated, message: "This will be removed in v2.0.0 of CalibreKit. Please migrate to `configuration`.")
    public static var baseURL: URL? {
        didSet {
            NetworkActivityIndicatorManager.shared.isEnabled = true
        }
    }
    
    public static var configuration: ServerConfiguration? {
        didSet {
            NetworkActivityIndicatorManager.shared.isEnabled = true
        }
    }
}
