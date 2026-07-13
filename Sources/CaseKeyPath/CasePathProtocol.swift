//
//  File.swift
//  
//
//  Created by Pau Blanes on 9/7/26.
//

import Foundation

///
/// Lets a generic constraint see inside a `CasePath`.
///
/// In a `KeyPath` extension, the key path's `Value` (a `CasePath`) is an opaque
/// box. This protocol surfaces its `Enum`, `AssociatedValue`, and `embed` so
/// `Value: CasePathProtocol` can reach them — the only way, since you can't
/// constrain to a struct or name its generics directly.
///
public protocol CasePathProtocol {
    associatedtype Enum
    associatedtype AssociatedValue
    
    var embed: (AssociatedValue) -> Enum { get }
    
    func extractAny(from root: Any) -> Any?
}
