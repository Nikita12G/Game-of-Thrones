//
//  Persons.swift
//  IceAndFire
//
//  Created by Никита Гуляев on 29.12.2021.
//
import Foundation

// MARK: - PersonElement
struct PersonElement: Codable {
    let charID: Int
    let name: String
    let birthday: Birthday
    let occupation: [String]
    let img: String
    let status: Status
    let nickname: String
    let appearance: [Int]
    let portrayed: String
    let category: Category
    let betterCallSaulAppearance: [Int]

    enum CodingKeys: String, CodingKey {
        case charID = "char_id"
        case name, birthday, occupation, img, status, nickname, appearance, portrayed, category
        case betterCallSaulAppearance = "better_call_saul_appearance"
    }
}

// MARK: PersonElement convenience initializers and mutators

extension PersonElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PersonElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        charID: Int? = nil,
        name: String? = nil,
        birthday: Birthday? = nil,
        occupation: [String]? = nil,
        img: String? = nil,
        status: Status? = nil,
        nickname: String? = nil,
        appearance: [Int]? = nil,
        portrayed: String? = nil,
        category: Category? = nil,
        betterCallSaulAppearance: [Int]? = nil
    ) -> PersonElement {
        return PersonElement(
            charID: charID ?? self.charID,
            name: name ?? self.name,
            birthday: birthday ?? self.birthday,
            occupation: occupation ?? self.occupation,
            img: img ?? self.img,
            status: status ?? self.status,
            nickname: nickname ?? self.nickname,
            appearance: appearance ?? self.appearance,
            portrayed: portrayed ?? self.portrayed,
            category: category ?? self.category,
            betterCallSaulAppearance: betterCallSaulAppearance ?? self.betterCallSaulAppearance
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Birthday: String, Codable {
    case the07081993 = "07-08-1993"
    case the08111970 = "08-11-1970"
    case the09071958 = "09-07-1958"
    case the09241984 = "09-24-1984"
    case unknown = "Unknown"
}

enum Category: String, Codable {
    case betterCallSaul = "Better Call Saul"
    case breakingBad = "Breaking Bad"
    case breakingBadBetterCallSaul = "Breaking Bad, Better Call Saul"
}

enum Status: String, Codable {
    case alive = "Alive"
    case deceased = "Deceased"
    case presumedDead = "Presumed dead"
    case unknown = "Unknown"
}

typealias Person = [PersonElement]

extension Array where Element == Person.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Person.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
