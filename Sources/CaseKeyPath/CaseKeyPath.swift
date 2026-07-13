//
//  File.swift
//  
//
//  Created by Pau Blanes on 9/7/26.
//

import Foundation

public typealias CaseKeyPath<Enum: CasePathable, AssociatedValue> = KeyPath<Enum.AllCasePaths, CasePath<Enum, AssociatedValue>>
public typealias PartialCaseKeyPath<Enum: CasePathable> = PartialKeyPath<Enum.AllCasePaths>

// Value is a CasePath and needs to conform to CasePathProtocol
// The CasePath enum needs to be CasePathable
// The KeyPath Root is AllCasePaths, so needs to be equal as CasePath Enum AllCasePaths
extension KeyPath where Value: CasePathProtocol, Value.Enum: CasePathable, Root == Value.Enum.AllCasePaths {
    public func callAsFunction(_ value: Value.AssociatedValue) -> Value.Enum {
        let casePath = Value.Enum.allCasePaths[keyPath: self]
        return casePath.embed(value)
    }
}
