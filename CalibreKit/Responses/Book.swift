//
//  Book.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

// TODO: take this out
// swiftlint:disable identifier_name

// TODO: see if any / all of these need to be optional?

public struct Book: ResponseSerializable {
    public let application_id: Int
    public let author_sort_map: [String: String] // TODO: subtype?
    public let authors: [String]
    public let comments: String?
    public let cover: CoverEndpoint
    
//    public let identifiers: [String: [String: String]] // TODO: subtype, also this isn't working, come back to it
    public let languages: [String] // TODO: enum?
    public let last_modified: String // TODO: date
    public let tags: [String]
    public let thumbnail: ThumbnailEndpoint
    public let title: String
    public let title_sort: String
}

// swiftlint:enable identifier_name
