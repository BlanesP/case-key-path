//
//  ModifyTests.swift
//  CaseKeyPath
//
//  Created by Pau Blanes on 18/07/2026.
//

import Testing
@testable import CaseKeyPath

struct ModifyTests {
    
    @Test func modifyUpdatesValueForMatchingCase() {
        // Arrange
        var payment: Payment = .card("123")
        
        // Act
        payment.modify(\.card) { _ in "111" }
        
        // Assert
        #expect(payment == .card("111"))
    }
    
    @Test func modifyUpdatesValueUsingCurrentForMatchingCase() {
        // Arrange
        var payment: Payment = .cash(10)
        
        // Act
        payment.modify(\.cash) { $0 * 2 }
        
        // Assert
        #expect(payment == .cash(20))
    }
    
    @Test func modifyUpdatesValueForMatchingMultiValueCase() {
        // Arrange
        var payment: Payment = .transfer(iban: "ES123", amount: 5)
        
        // Act
        payment.modify(\.transfer) { _ in ("DE123", 5) }
        
        // Assert
        #expect(payment == .transfer(iban: "DE123", amount: 5))
    }
    
    @Test func modifyIgnoresValueForNonMatchingCase() {
        // Arrange
        var payment: Payment = .cash(10)
        
        // Act
        payment.modify(\.card) { _ in "111" }
        
        // Assert
        #expect(payment == .cash(10))
    }
    
    @Test func modifyingReturnsValueForMatchingCase() {
        // Arrange
        let payment: Payment = .card("123")
        
        // Act
        let result = payment.modifying(\.card) { _ in "111" }
        
        // Assert
        #expect(payment == .card("123"))
        #expect(result == .card("111"))
    }
    
    @Test func modifyingReturnsValueUsingCurrentForMatchingCase() {
        // Arrange
        let payment: Payment = .cash(10)
        
        // Act
        let result = payment.modifying(\.cash) { $0 * 2 }
        
        // Assert
        #expect(payment == .cash(10))
        #expect(result == .cash(20))
    }
    
    @Test func modifyingReturnsValueForMatchingMultiValueCase() {
        // Arrange
        let payment: Payment = .transfer(iban: "ES123", amount: 5)
        
        // Act
        let result = payment.modifying(\.transfer) { _ in ("DE123", 5) }
        
        // Assert
        #expect(payment == .transfer(iban: "ES123", amount: 5))
        #expect(result == .transfer(iban: "DE123", amount: 5))
    }
    
    @Test func modifyingReturnsSameValueForNonMatchingCase() {
        // Arrange
        let payment: Payment = .cash(10)
        
        // Act
        let result = payment.modifying(\.card) { _ in "111" }
        
        // Assert
        #expect(payment == .cash(10))
        #expect(result == .cash(10))
    }
}
