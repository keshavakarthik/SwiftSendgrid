//
//  StringValuePairConvertible.swift
//  SendgridSwift
//
//  Created by Keshava Karthik on 21/12/19.
//

import Foundation

typealias StringValuePair = [String: Any]

protocol StringValuePairConvertible {
    var stringValuePairs: StringValuePair {get}
}

extension Array where Element : StringValuePairConvertible {
    var stringValuePairs: [StringValuePair] {
        return self.map { $0.stringValuePairs }
    }
}
