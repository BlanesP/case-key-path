//
//  demo4_embedding.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

import CasePathable

/*
 Goal: update the associated value of a specific case across a collection,
 leaving other cases untouched. E.g. discount all cash payments.
 */
func demo4_embedding() {
    let payments: [Payment] = [.cash(10), .card("visa"), .cash(20), .free, .transfer(iban: "ES123", amount: 2)]

    // ❌ Vanilla: the case is baked in twice — read it (`if case let .cash`) AND rebuild it (`.cash(...)`)
    let vanillaDiscounted = payments.map { payment -> Payment in
        if case let .cash(amount) = payment {
            return .cash(amount / 2)
        } else {
            return payment
        }
    }

    // ✅ Case paths: one path drives BOTH directions — extract, transform, embed back
    let casePathDiscounted = payments.map { $0.modifying(\.cash) { $0 / 2 } }

    print("""
    --- demo4_embedding ---

    Vanilla discounted:   \(vanillaDiscounted)
    CasePaths discounted: \(casePathDiscounted)

    """)
}
