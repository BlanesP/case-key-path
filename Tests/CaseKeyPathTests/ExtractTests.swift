import Testing
@testable import CaseKeyPath

struct ExtractTests {

    @Test func extractReturnsValueForMatchingCase() {
        // Arrange
        let payment = Payment.cash(10)
        
        // Act
        let value = payment[case: \.cash]
        
        // Assert
        #expect(value == 10)
    }

    @Test func extractReturnsBothValuesForMatchingMultiValueCase() throws {
        // Arrange
        let payment = Payment.transfer(iban: "ES123", amount: 10)
        
        // Act
        let value = try #require(payment[case: \.transfer])
        
        // Assert
        #expect(value.0 == "ES123")
        #expect(value.1 == 10)
    }

    @Test func extractReturnsNilForNonMatchingCase() {
        // Arrange
        let payment = Payment.cash(10)

        // Act
        let value = payment[case: \.card]

        // Assert
        #expect(value == nil, "Extracting a non-matching case must return nil")
    }

    @Test func extractReturnsNonNilForMatchingValuelessCase() {
        // Arrange
        let payment = Payment.free

        // Act
        let value: Void? = payment[case: \.free]

        // Assert (Void isn't Equatable, so assert on presence, not equality)
        #expect(value != nil)
    }

    @Test func extractReturnsNilForNonMatchingValuelessCase() {
        // Arrange
        let payment = Payment.cash(10)

        // Act
        let value: Void? = payment[case: \.free]

        // Assert
        #expect(value == nil)
    }
    
    @Test func extractAnyReturnsNilForWrongRootType() {
        // Arrange
        let casePath = Payment.allCasePaths.card
        
        // Act
        let anyValue = casePath.extractAny(from: "Non Payment case")
        
        // Assert
        #expect(anyValue == nil)
    }
}
