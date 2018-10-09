//
//  BooksEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

public struct BooksEndpoint: Endpoint {
    public typealias ParsedResponse = BooksResponse
    public let method: HTTPMethod = .get
    public let relativePath = "/ajax/books/"
    
    public init() {}
}
