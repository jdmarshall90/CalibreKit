//
//  ResponseObjectSerializable.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

// modified from: https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#generic-response-object-serialization
public protocol ResponseObjectSerializable {
    init(representation: [String: [String: Any]]) throws
}