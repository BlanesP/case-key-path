//
//  File.swift
//  
//
//  Created by Pau Blanes on 7/7/26.
//

import Foundation

public struct CasePath<Enum, AssociatedValue>: CasePathProtocol {
    public let extract: (Enum) -> AssociatedValue?
    public let embed: (AssociatedValue) -> Enum

    public init(
        extract: @escaping (Enum) -> AssociatedValue?,
        embed: @escaping (AssociatedValue) -> Enum
    ) {
        self.extract = extract
        self.embed = embed
    }
    
    public func extractAny(from root: Any) -> Any? {
        guard let enumRoot = root as? Enum else { return nil }
        return extract(enumRoot)
    }
}
