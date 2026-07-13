//
//  demo2_abstraction.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

import CaseKeyPath

/*
 Goal: do the same extraction of demo_1 with ONE generic helper — passing the case as a
 value instead of rewriting the logic per case. E.g. compactMap(\.cash), (\.card)…
 */
func demo2_abstraction() {
    let payments: [Payment] = [.cash(10), .card("visa"), .cash(20), .free, .transfer(iban: "ES123", amount: 2)]
    
    // ❌ Vanilla: no way to write ONE helper over all cases — you rewrite the extraction each time
    let vanillaCashValues = payments.compactMap {
        if case let .cash(value) = $0 {
            return value
        } else {
            return nil
        }
    }
    
    let vanillaCardValues = payments.compactMap {
        if case let .card(value) = $0 {
            return value
        } else {
            return nil
        }
    }
    
    let vanillaTransferValues = payments.compactMap {
        if case let .transfer(iban, amount) = $0 {
            return (iban, amount)
        } else {
            return nil
        }
    }
    
    // ✅ Case paths: a case path is a value, so one generic compactMap takes the case as a parameter
    let newCashValues = payments.compactMap(\.cash)
    let newCardValues = payments.compactMap(\.card)
    let newTransferValues = payments.compactMap(\.transfer)
    
    print("""
    --- demo2_abstraction ---
    
    Vanilla cash values: \(vanillaCashValues)
    Vanilla card values: \(vanillaCardValues)
    Vanilla transfer values: \(vanillaTransferValues)
    
    CasePaths cash values: \(newCashValues)
    CasePaths card values: \(newCardValues)
    CasePaths transfer values: \(newTransferValues)
    
    """)

}
