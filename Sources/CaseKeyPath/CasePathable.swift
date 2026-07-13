//
//  File.swift
//  
//
//  Created by Pau Blanes on 9/7/26.
//

import Foundation

public protocol CasePathable {
    associatedtype AllCasePaths
    static var allCasePaths: AllCasePaths { get }
}

extension CasePathable {
    // A subscript lets you use [ ] brackets on a type to get or set a value — like indexing.
    // Subscripts, unlike functions, have no argument label by default
    // If we have no case as param name we can use it with [X] instead of [case: X]
    public subscript<AssociatedValue>(case keyPath: CaseKeyPath<Self, AssociatedValue>) -> AssociatedValue? {
        // get = extract, set = embed — the two directions of the case path.
        get {
            Self.allCasePaths[keyPath: keyPath].extract(self)
        }
        set {
            // Only write when we're already in this case (so a stale binding can't
            // clobber a different case), and never when clearing to nil.
            guard let newValue, self[case: keyPath] != nil else { return }
            self = Self.allCasePaths[keyPath: keyPath].embed(newValue)
        }
    }
    
    public func `is`(_ keyPath: PartialCaseKeyPath<Self>) -> Bool {
        let anyCasePath = Self.allCasePaths[keyPath: keyPath] as? any CasePathProtocol
        let anyAssociatedValue = anyCasePath?.extractAny(from: self)
        return anyAssociatedValue != nil
    }
}
