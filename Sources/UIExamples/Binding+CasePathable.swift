//
//  Binding+CasePathable.swift
//  CasePathable
//
//  SwiftUI integration kept OUT of the core library (so importing `CasePathable`
//  doesn't drag in SwiftUI).
//
//  Modeled on the swift-case-paths README: `@dynamicMemberLookup` so you can write
//  `$destination.edit`, and it captures directly with no Sendable ceremony (Swift 6
//  may emit concurrency warnings — the reference example accepts them too).
//

import SwiftUI
import CaseKeyPath

extension Binding where Value: CasePathable {
    subscript<CaseValue>(dynamicMember keyPath: CaseKeyPath<Value, CaseValue>) -> Binding<CaseValue>? {
        guard let caseValue = wrappedValue[case: keyPath] else { return nil }
        return Binding<CaseValue>(
            get: { wrappedValue[case: keyPath] ?? caseValue },
            set: { wrappedValue[case: keyPath] = $0 }
        )
    }
}

extension Binding {
    subscript<Enum: CasePathable, CaseValue>(
        dynamicMember keyPath: CaseKeyPath<Enum, CaseValue>
    ) -> Binding<CaseValue?> where Value == Enum? {
        Binding<CaseValue?>(
            get: { wrappedValue?[case: keyPath] },
            set: { newValue in
                if let newValue {
                    wrappedValue = keyPath(newValue)             // present / update
                } else if wrappedValue?[case: keyPath] != nil {
                    wrappedValue = nil                            // dismiss
                }
            }
        )
    }
}
