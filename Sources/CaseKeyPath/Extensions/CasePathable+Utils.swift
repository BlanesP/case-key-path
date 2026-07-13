//
//  CasePathable+Utils.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

extension CasePathable {
    /// In place: transform the value inside `path`'s case, if present.
    ///
    /// Uses the case path in BOTH directions — `[case:]` get to extract, `[case:]`
    /// set to embed the transformed value back into the same case.
    public mutating func modify<Value>(_ path: CaseKeyPath<Self, Value>, _ transform: (Value) -> Value) {
        guard let value = self[case: path] else { return }
        self[case: path] = transform(value)
    }

    /// Returns a copy with `path`'s case value transformed, leaving other cases untouched.
    public func modifying<Value>(_ path: CaseKeyPath<Self, Value>, _ transform: (Value) -> Value) -> Self {
        var copy = self
        copy.modify(path, transform)
        return copy
    }
}
