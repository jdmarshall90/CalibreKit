//
//  CalibreError.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

public enum CalibreError: Error {
    // swiftlint:disable:next identifier_name
    case message(String)
    
    public var localizedDescription: String {
        switch self {
        case .message(let description):
            return description
        }
    }
}
