//
//  Sequence+Utils.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

extension Sequence where Element: CasePathable {
    /// Collect the associated values of one case from the sequence.
    public func compactMap<Value>(_ path: CaseKeyPath<Element, Value>) -> [Value] {
        compactMap { $0[case: path] }
    }

    /// Keep only the elements that are the given case.
    public func filter(is path: PartialCaseKeyPath<Element>) -> [Element] {
        filter { $0.is(path) }
    }

    /// Count the elements that are the given case.
    public func count(is path: PartialCaseKeyPath<Element>) -> Int {
        count { $0.is(path) }
    }

    /// Whether any element is the given case.
    public func contains(_ path: PartialCaseKeyPath<Element>) -> Bool {
        contains { $0.is(path) }
    }
}
