//
//  Payment.swift
//  CaseKeyPath
//
//  Created by Pau Blanes on 17/07/2026.
//

@testable import CaseKeyPath

@CasePathable
enum Payment: Equatable {
    case card(String)
    case coupon(String)
    case cash(Int)
    case free
    case transfer(iban: String, amount: Int)
}
