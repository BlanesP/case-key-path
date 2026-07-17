//
//  IsTests.swift
//  CaseKeyPath
//
//  Created by Pau Blanes on 17/07/2026.
//

import Testing
@testable import CaseKeyPath

struct IsTests {
    
    @Test func isReturnsTrueForMatchingCase() {
        // Arrange
        let payment = Payment.cash(10)
        
        // Act
        let isCash = payment.is(\.cash)
        
        // Assert
        #expect(isCash)
    }
    
    @Test func isReturnsFalseForNonMatchingCase() {
        // Arrange
        let payment = Payment.cash(10)
        
        // Act
        let isCard = payment.is(\.card)
        
        // Assert
        #expect(!isCard)
    }
    
    @Test func isReturnsTrueForMatchingMultiValueCase() {
        // Arrange
        let payment = Payment.transfer(iban: "", amount: 0)
        
        // Act
        let isTransfer = payment.is(\.transfer)
        
        // Assert
        #expect(isTransfer)
    }
    
    @Test func isReturnsTrueForMatchingValuelessCase() {
        // Arrange
        let payment = Payment.free
        
        // Act
        let isFree = payment.is(\.free)
        
        // Assert
        #expect(isFree)
    }
    
    @Test func isReturnsFalseForNonMatchingSameValueTypeCase() {
        // Arrange
        let payment = Payment.card("123")
        
        // Act
        let isCoupon = payment.is(\.coupon)
        
        // Assert
        #expect(!isCoupon)
    }
}
