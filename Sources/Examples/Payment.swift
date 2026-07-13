//
//  Payment.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

import CaseKeyPath

@CasePathable
enum Payment {
    case card(String)
    case cash(Int)
    case free
    case transfer(iban: String, amount: Int)
}
