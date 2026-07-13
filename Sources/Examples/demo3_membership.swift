//
//  demo3_membership.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

import CasePathable

/*
 Goal: test which case a value is (membership), ignoring the associated value.
 E.g. filter, count, or check payments by their case.
 */
func demo3_membership() {
    let payments: [Payment] = [.cash(10), .card("visa"), .cash(20), .free, .transfer(iban: "ES123", amount: 2)]

    // ❌ Vanilla: `if case` is a statement, so a membership test needs a `{ true } else { false }` wrapper. No way to make a generic check
    let vanillaCashPayments = payments.filter {
        if case .cash = $0 { return true } else { return false }
    }
    let vanillaFreeCount = payments.filter {
        if case .free = $0 { return true } else { return false }
    }.count
    let vanillaHasTransfer = payments.contains {
        if case .transfer = $0 { return true } else { return false }
    }

    // ✅ Case paths: because a case is a value, you can build a generic filter(is:) / count(is:) / contains that accept it as a parameter
    let casePathCashPayments = payments.filter(is: \.cash)
    let casePathFreeCount = payments.count(is: \.free)
    let casePathHasTransfer = payments.contains(\.transfer)

    print("""
    --- demo3_membership ---

    Vanilla cash payments: \(vanillaCashPayments)
    Vanilla free count: \(vanillaFreeCount)
    Vanilla has transfer: \(vanillaHasTransfer)

    CasePaths cash payments: \(casePathCashPayments)
    CasePaths free count: \(casePathFreeCount)
    CasePaths has transfer: \(casePathHasTransfer)

    """)
}
