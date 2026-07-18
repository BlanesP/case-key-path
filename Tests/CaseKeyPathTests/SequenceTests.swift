//
//  SequenceTests.swift
//  CaseKeyPath
//
//  Created by Pau Blanes on 18/07/2026.
//

import Testing
@testable import CaseKeyPath

struct SequenceTests {

    // MARK: - CompactMap

    @Test func compactMapFindsMatchingCases() {
        // Arrange
        let payments: [Payment] = [.card("444"), .cash(5), .card("123"), .transfer(iban: "ES123", amount: 10), .free, .coupon("1111")]

        // Act
        let result = payments.compactMap(\.card)

        // Assert
        #expect(result == ["444", "123"])
    }

    @Test func compactMapFindsMatchingMultiValueCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.compactMap(\.transfer)

        // Assert
        #expect(result.count == 1)
        #expect(result[0].0 == "ES123")
        #expect(result[0].1 == 10)
    }

    @Test func compactMapFindsMatchingValuelessCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result: [Void] = payments.compactMap(\.free)

        // Assert
        #expect(result.count == 1)
        #expect(result[0] == ())
    }

    @Test func compactMapReturnsEmptyForNonMatchingCase() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.compactMap(\.coupon)

        // Assert
        #expect(result.isEmpty)
    }

    @Test func compactMapReturnsEmptyForEmptySequence() {
        // Arrange
        let payments: [Payment] = []

        // Act
        let result = payments.compactMap(\.card)

        // Assert
        #expect(result.isEmpty)
    }

    // MARK: - Filter

    @Test func filterFindsMatchingCases() {
        // Arrange
        let payments: [Payment] = [.card("444"), .cash(5), .card("123"), .transfer(iban: "ES123", amount: 10), .free, .coupon("1111")]

        // Act
        let result = payments.filter(is: \.card)

        // Assert
        #expect(result == [.card("444"), .card("123")])
    }

    @Test func filterFindsMatchingMultiValueCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.filter(is: \.transfer)

        // Assert
        #expect(result == [.transfer(iban: "ES123", amount: 10)])
    }

    @Test func filterFindsMatchingValuelessCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.filter(is: \.free)

        // Assert
        #expect(result == [.free])
    }

    @Test func filterReturnsEmptyForNonMatchingCase() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.filter(is: \.coupon)

        // Assert
        #expect(result.isEmpty)
    }

    @Test func filterReturnsEmptyForEmptySequence() {
        // Arrange
        let payments: [Payment] = []

        // Act
        let result = payments.filter(is: \.card)

        // Assert
        #expect(result.isEmpty)
    }

    // MARK: - Count

    @Test func countReturnsNumberOfMatchingCases() {
        // Arrange
        let payments: [Payment] = [.card("444"), .cash(5), .card("123"), .transfer(iban: "ES123", amount: 10), .free, .coupon("1111")]

        // Act
        let result = payments.count(is: \.card)

        // Assert
        #expect(result == 2)
    }

    @Test func countReturnsNumberOfMatchingMultiValueCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.count(is: \.transfer)

        // Assert
        #expect(result == 1)
    }

    @Test func countReturnsNumberOfMatchingValuelessCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.count(is: \.free)

        // Assert
        #expect(result == 1)
    }

    @Test func countReturnsZeroForNonMatchingCase() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.count(is: \.coupon)

        // Assert
        #expect(result == 0)
    }

    @Test func countReturnsZeroForEmptySequence() {
        // Arrange
        let payments: [Payment] = []

        // Act
        let result = payments.count(is: \.card)

        // Assert
        #expect(result == 0)
    }

    // MARK: - Contains

    @Test func containsReturnsTrueForMatchingCases() {
        // Arrange
        let payments: [Payment] = [.card("444"), .cash(5), .card("123"), .transfer(iban: "ES123", amount: 10), .free, .coupon("1111")]

        // Act
        let result = payments.contains(\.card)

        // Assert
        #expect(result)
    }

    @Test func containsReturnsTrueForMatchingMultiValueCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.contains(\.transfer)

        // Assert
        #expect(result)
    }

    @Test func containsReturnsTrueForMatchingValuelessCases() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.contains(\.free)

        // Assert
        #expect(result)
    }

    @Test func containsReturnsFalseForNonMatchingCase() {
        // Arrange
        let payments: [Payment] = [.cash(3), .card("123"), .cash(5), .transfer(iban: "ES123", amount: 10), .free]

        // Act
        let result = payments.contains(\.coupon)

        // Assert
        #expect(!result)
    }

    @Test func containsReturnsFalseForEmptySequence() {
        // Arrange
        let payments: [Payment] = []

        // Act
        let result = payments.contains(\.card)

        // Assert
        #expect(!result)
    }
}
