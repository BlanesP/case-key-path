//
//  EmbedTests.swift
//  CaseKeyPath
//
//  Created by Pau Blanes on 17/07/2026.
//

import Testing
@testable import CaseKeyPath

struct EmbedTests {
    
    @Test func embedUpdatesValueForMatchingCase() {
        // Arrange
        var payment = Payment.cash(10)
        
        // Act
        payment[case: \.cash] = 99
        
        // Assert
        #expect(payment == .cash(99))
    }
    
    @Test func embedUpdatesBothValuesForMatchingMultiValueCase() {
        // Arrange
        var payment = Payment.transfer(iban: "ES123", amount: 20)
        
        // Act
        payment[case: \.transfer] = ("ES000", 5)
        
        // Assert
        #expect(payment == .transfer(iban: "ES000", amount: 5))
    }
    
    @Test func embedIgnoresWriteForNonMatchingCase() {
        // Arrange
        var payment = Payment.cash(10)
        
        // Act
        payment[case: \.card] = "1234"
        
        // Assert
        #expect(payment == .cash(10))
    }
    
    @Test func embedIgnoresWriteForNilValue() {
        // Arrange
        var payment = Payment.cash(10)
        
        // Act
        payment[case: \.cash] = nil
        
        // Assert
        #expect(payment == .cash(10))
    }
    
    @Test func extractThenEmbedPreservesValue() {
        // Arrange
        var payment = Payment.cash(10)

        // Act
        let value = payment[case: \.cash]
        payment[case: \.cash] = value

        // Assert
        #expect(payment == .cash(10))
    }

    @Test func callAsFunctionEmbedsValueForSingleValueCase() {
        // Arrange
        let cashPath: CaseKeyPath<Payment, Int> = \.cash

        // Act
        let result = cashPath(5)

        // Assert
        #expect(result == .cash(5))
    }

    @Test func callAsFunctionEmbedsBothValuesForMultiValueCase() {
        // Arrange
        let cashPath: CaseKeyPath<Payment, (String, Int)> = \.transfer

        // Act
        let result = cashPath(("ES123", 10))

        // Assert
        #expect(result == .transfer(iban: "ES123", amount: 10))
    }

    @Test func callAsFunctionEmbedsValuelessCase() {
        // Arrange
        let cashPath: CaseKeyPath<Payment, Void> = \.free

        // Act
        let result = cashPath()

        // Assert
        #expect(result == .free)
    }
}
