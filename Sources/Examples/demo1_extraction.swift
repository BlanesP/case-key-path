//
//  demo1_extraction.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

import CaseKeyPath

/*
 Goal: pull the associated values of a specific case out of a mixed collection.
 E.g. collect every cash amount from a list of payments.
 */
func demo1_extraction() {
    let payments: [Payment] = [.cash(10), .card("visa"), .cash(20), .free, .transfer(iban: "ES123", amount: 2)]
    
    // ❌ Vanilla: every case needs its own multi-line `if case let` just to pull the value out
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
    
    // ✅ Case paths: one concise expression — `$0[case: \.x]` — extracts any case the same way
    let newCashValues = payments.compactMap { $0[case: \.cash] }
    let newCardValues = payments.compactMap { $0[case: \.card] }
    let newTransferValues = payments.compactMap { $0[case: \.transfer] }
    
    print("""
    --- demo1_extraction ---
    
    Vanilla cash values: \(vanillaCashValues)
    Vanilla card values: \(vanillaCardValues)
    Vanilla transfer values: \(vanillaTransferValues)
    
    CasePaths cash values: \(newCashValues)
    CasePaths card values: \(newCardValues)
    CasePaths transfer values: \(newTransferValues)
    
    """)
}
