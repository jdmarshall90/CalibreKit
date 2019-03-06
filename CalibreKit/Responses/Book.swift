//
//  Book.swift
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

import Foundation

public struct Book: ResponseSerializable, Equatable {
    internal enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case id = "application_id"
        case addedOn = "timestamp"
        case comments
        case cover
        case formats
        case identifiers
        case languages
        case lastModified = "last_modified"
        case mainFormat = "main_format"
        case tags
        case thumbnail
        case title
        case titleSort = "title_sort"
        case authors
        case authorSortMap = "author_sort_map"
        case publishedDate = "pubdate"
        case rating
        case series
        case seriesIndex = "series_index"
    }
    
    // swiftlint:disable:next identifier_name
    public let id: Int
    public let addedOn: Date?
    public let authors: [Author]
    public let comments: String?
    public let cover: CoverEndpoint
    public let identifiers: [Identifier]
    public let languages: [Language]
    public let lastModified: Date?
    public let tags: [String]
    public let thumbnail: ThumbnailEndpoint
    public let title: Title
    public let publishedDate: Date?
    public let rating: Rating
    public let series: Series?
    public let formats: [Format]
    public let mainFormat: BookDownloadEndpoint?
    
    public struct Author: Hashable, Codable {
        public let name: String
        public let sort: String
        
        public init(name: String, sort: String) {
            self.name = name
            self.sort = sort
        }
    }
    
    public enum Format: Codable {
        case acsm
        case azw
        case azw3
        case epub
        case pdf
        case other(String)
        
        private var serverValue: String {
            switch self {
            case .acsm:
                return "acsm"
            case .azw:
                return "azw"
            case .azw3:
                return "azw3"
            case .epub:
                return "epub"
            case .pdf:
                return "pdf"
            case .other(let value):
                return value
            }
        }
        
        public var displayValue: String {
            return serverValue.uppercased()
        }
        
        public init(from decoder: Decoder) throws {
            let rawValue = try decoder.singleValueContainer().decode(String.self)
            self.init(serverValue: rawValue)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(serverValue)
        }
        
        internal init(serverValue: String) {
            switch serverValue.lowercased().trimmingCharacters(in: .whitespaces) {
            case Format.acsm.serverValue.lowercased(),
                 Format.acsm.displayValue.lowercased():
                self = .acsm

            case Format.azw.serverValue.lowercased(),
                 Format.azw.displayValue.lowercased():
                self = .azw

            case Format.azw3.serverValue.lowercased(),
                 Format.azw3.displayValue.lowercased():
                self = .azw3

            case Format.epub.serverValue.lowercased(),
                 Format.epub.displayValue.lowercased():
                self = .epub

            case Format.pdf.serverValue.lowercased(),
                 Format.pdf.displayValue.lowercased():
                self = .pdf

            default:
                self = .other(serverValue.trimmingCharacters(in: .whitespaces))
            }
        }
    }
    
    public enum Identifier: Hashable {
        case isbn(String)
        case google(String)
        case other(source: String, uniqueID: String)
        
        private var serverValue: String? {
            switch self {
            case .isbn:
                return "isbn"
            case .google:
                return "google"
            case .other:
                return nil
            }
        }
        
        public var displayValue: String {
            switch self {
            case .isbn:
                return "ISBN"
            case .google:
                return "Google"
            case .other(let source, _):
                return source
            }
        }
        
        public var uniqueID: String {
            switch self {
            case .isbn(let uniqueID),
                 .google(let uniqueID),
                 .other(_, let uniqueID):
                return uniqueID
            }
        }
        
        public init(source: String, uniqueID: String) {
            switch source {
            case Identifier.isbn("").serverValue:
                self = .isbn(uniqueID)
            case Identifier.google("").serverValue:
                self = .google(uniqueID)
            default:
                self = .other(source: source, uniqueID: uniqueID)
            }
        }
    }
    
    public enum Language: ResponseSerializable, Hashable {
        case english
        case latin
        case russian
        case spanish
        case other(String)
        
        private var serverValue: String? {
            switch self {
            case .english:
                return "eng"
            case .latin:
                return "lat"
            case .russian:
                return "rus"
            case .spanish:
                return "spa"
            case .other:
                return nil
            }
        }
        
        public var displayValue: String {
            switch self {
            case .english:
                return "English"
            case .latin:
                return "Latin"
            case .russian:
                return "Russian"
            case .spanish:
                return "Spanish"
            case .other(let language):
                return language
            }
        }
        
        public init(displayValue: String) {
            switch displayValue.lowercased().trimmingCharacters(in: .whitespaces) {
            case Language.english.serverValue?.lowercased(),
                 Language.english.displayValue.lowercased():
                self = .english
                
            case Language.latin.serverValue?.lowercased(),
                 Language.latin.displayValue.lowercased():
                self = .latin
                
            case Language.russian.serverValue?.lowercased(),
                 Language.russian.displayValue.lowercased():
                self = .russian
                
            case Language.spanish.serverValue?.lowercased(),
                 Language.spanish.displayValue.lowercased():
                self = .spanish
                
            default:
                self = .other(displayValue.trimmingCharacters(in: .whitespaces))
            }
        }
        
        public init(from decoder: Decoder) throws {
            let rawValue = try decoder.singleValueContainer().decode(String.self)
            self.init(displayValue: rawValue)
        }
    }
    
    public struct Title: Hashable, Codable {
        public let name: String
        public let sort: String
        
        public init(name: String, sort: String) {
            self.name = name
            self.sort = sort
        }
    }
    
    public enum Rating: Int, ResponseSerializable, CaseIterable, Hashable, Encodable {
        case unrated
        case oneStar
        case twoStars
        case threeStars
        case fourStars
        case fiveStars
        
        public var displayValue: String {
            switch self {
            case .unrated:
                return "⭒⭒⭒⭒⭒"
            case .oneStar:
                return "⭑⭒⭒⭒⭒"
            case .twoStars:
                return "⭑⭑⭒⭒⭒"
            case .threeStars:
                return "⭑⭑⭑⭒⭒"
            case .fourStars:
                return "⭑⭑⭑⭑⭒"
            case .fiveStars:
                return "⭑⭑⭑⭑⭑"
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawRating = try container.decode(Int.self)
            guard let rating = Rating(rawValue: rawRating) else {
                throw CalibreError.message("Expected rating of 0-5, but got \(rawRating).")
            }
            self = rating
        }
    }
    
    public struct Series: Hashable, Codable {
        private static let seriesIndexFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            return formatter
        }()
        
        public var displayValue: String {
            let displayIndex = "#\(Series.seriesIndexFormatter.string(from: NSNumber(value: index)) ?? "UNKNOWN")"
            return "\(name) \(displayIndex)"
        }
        
        public let name: String
        public let index: Double
        
        public init(name: String, index: Double) {
            self.name = name
            self.index = index
        }
    }
    
    public static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.addedOn = try container.decodeDate(forKey: .addedOn)
        
        let rawAuthors = try container.decode([String].self, forKey: .authors)
        let rawAuthorSortMap = try container.decode([String: String].self, forKey: .authorSortMap)
        self.authors = rawAuthors.map { Author(name: $0, sort: rawAuthorSortMap[$0] ?? $0) }
        
        self.comments = try container.decodeIfPresent(String.self, forKey: .comments)
        self.cover = try container.decode(CoverEndpoint.self, forKey: .cover)
        
        self.formats = try container.decode([Format].self, forKey: .formats)
        
        if let mainFormat = try container.decodeIfPresent(Dictionary<String, String>.self, forKey: .mainFormat),
            let mainFormatURL = mainFormat.values.first,
            // this will try to parse something like: "/get/epub/BOOK_ID/LIBRARY_NAME"
            let formatString = mainFormatURL.split(separator: "/").dropFirst().first {
            let format = Format(serverValue: String(formatString))
            self.mainFormat = BookDownloadEndpoint(relativePath: mainFormatURL, format: format)
        } else {
            self.mainFormat = nil
        }
        
        let rawIdentifiers = try container.decode([String: String].self, forKey: .identifiers)
        self.identifiers = rawIdentifiers.map { Identifier(source: $0.key, uniqueID: $0.value) }
        
        self.languages = try container.decode([Language].self, forKey: .languages)
        self.lastModified = try container.decodeDate(forKey: .lastModified)
        self.tags = try container.decode([String].self, forKey: .tags)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        let rawTitleSort = try container.decodeIfPresent(String.self, forKey: .titleSort)
        self.title = Title(name: rawTitle, sort: rawTitleSort ?? rawTitle)
        
        self.thumbnail = try container.decode(ThumbnailEndpoint.self, forKey: .thumbnail)
        
        self.publishedDate = try container.decodeDate(forKey: .publishedDate)
        do {
            self.rating = try container.decodeIfPresent(Rating.self, forKey: .rating) ?? .unrated
        } catch let error as CalibreError {
            throw CalibreError.message("Error in book \"\(title.name)\"'s rating: " + error.localizedDescription)
        }
        
        if let seriesName = try container.decodeIfPresent(String.self, forKey: .series),
            let seriesIndex = try container.decodeIfPresent(Double.self, forKey: .seriesIndex) {
            self.series = Series(name: seriesName, index: seriesIndex)
        } else {
            self.series = nil
        }
    }
}

private extension KeyedDecodingContainer where Key == Book.CodingKeys {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    func decodeDate(forKey key: Key) throws -> Date? {
        guard var rawDate = try decodeIfPresent(String.self, forKey: key) else { return nil }
        // Most dates are coming back looking like: "2018-11-21T16:27:09+00:00".
        // Some, however, look like: "2019-01-29T03:35:00.046910+00:00".
        // It is easier to just strip out the fractional seconds than to create
        // a new date formatter.
        if let indexOfPeriod = rawDate.index(of: "."),
            let indexOfPlus = rawDate.index(of: "+") {
            rawDate.removeSubrange(indexOfPeriod..<indexOfPlus)
        }
        let date = KeyedDecodingContainer<K>.dateFormatter.date(from: rawDate)
        return date
    }
}
