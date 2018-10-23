//
//  Cache.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/22/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

public struct Cache {
    private init() {}
    
    public static func clear() {
        // Long term, this caching will likely need to be ripped out and made scalable.
        // Good enough for now, though.
        ImageEndpoint.Cache.cache.removeAll()
    }
}
