import XCTest
@testable import CardSwipeKit
import SwiftUI

final class CardSwipeKitTests: XCTestCase {
    
    // ViewModel instance to be used in tests
    var viewModel: ViewModel!
    
    // Set up the environment before each test
    override func setUp() {
        super.setUp()
        // Initialize the ViewModel with animations enabled
        viewModel = ViewModel(isAnimated: true)
    }
    
    // Clean up after each test
    override func tearDown() {
        // Deallocate the ViewModel instance
        viewModel = nil
        super.tearDown()
    }
    
    // Test case for swipe back action
    func testSwipeBack() {
        let initialCardIndex = 1
        // Set the initial state
        viewModel.topCardIndex = initialCardIndex
        viewModel.offset = CGSize.zero

        let expectation = XCTestExpectation(description: "Wait for swipe back animation")
        
        // Perform the swipe back action
        viewModel.swipeBack()
        
        // Wait for the animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        // Verify that the top card index is decremented and offset is reset
        XCTAssertEqual(viewModel.topCardIndex, initialCardIndex - 1, "Top card index should decrement after swipe back")
        XCTAssertEqual(viewModel.offset, CGSize.zero, "Offset should reset after swipe back")
    }
    
    // Test case for handling swipe below threshold
    func testHandleSwipeBelowThreshold() {
        let smallSwipeTranslation = CGSize(width: 50, height: 0)
        // Perform the swipe action with small translation
        viewModel.handleSwipe(translation: smallSwipeTranslation)
        
        // Verify that the offset resets and top card index remains the same
        XCTAssertEqual(viewModel.offset, CGSize.zero, "Offset should reset for swipe under threshold")
        XCTAssertEqual(viewModel.topCardIndex, 0, "Top card index should remain the same for small swipe")
    }
    
    // Test case for handling swipe above threshold
    func testHandleSwipeAboveThreshold() {
        let largeSwipeTranslation = CGSize(width: 200, height: 0)
        let expectation = XCTestExpectation(description: "Wait for swipe animation")
        // Perform the swipe action with large translation
        viewModel.handleSwipe(translation: largeSwipeTranslation)
        
        // Wait for the animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        // Verify that the top card index increments and offset resets
        XCTAssertEqual(viewModel.topCardIndex, 1, "Top card index should increment after large swipe")
        XCTAssertEqual(viewModel.offset, CGSize.zero, "Offset should reset after swipe")
    }
    
    // Test case for carousel offset calculation
    func testCarouselOffset() {
        viewModel.type = .carousel
        viewModel.carouselSpace = 100
        let offset = viewModel.offset(for: 1)
        
        // Verify that the offset is calculated correctly for carousel
        XCTAssertEqual(offset, CGSize(width: 100, height: 0), "Carousel offset should be calculated correctly")
    }
    
    // Test case for deck offset calculation
    func testDeckOffset() {
        viewModel.type = .deck
        viewModel.offset = CGSize(width: 50, height: 50)
        let offset = viewModel.offset(for: viewModel.topCardIndex)
        
        // Verify that the deck offset matches the gesture's translation
        XCTAssertEqual(offset, CGSize(width: 50, height: 50), "Deck offset should match the gesture's translation")
    }
    
    // Test case for card scale calculation
    func testScale() {
        let scale = viewModel.scale(for: viewModel.topCardIndex)
        // Verify that the top card has a scale of 1.0
        XCTAssertEqual(scale, 1.0, "The top card should have a scale of 1.0")
        
        let otherScale = viewModel.scale(for: viewModel.topCardIndex + 1)
        // Verify that other cards have a smaller scale
        XCTAssertEqual(otherScale, 0.95, "Other cards should have a smaller scale")
    }
    
    // Test case for card rotation calculation
    func testRotation() {
        viewModel.offset = CGSize(width: 200, height: 0)
        let rotation = viewModel.rotation(for: viewModel.topCardIndex)
        
        // Verify that the card rotation is proportional to the horizontal swipe offset
        XCTAssertEqual(rotation.degrees, 10.0, "The card rotation should be proportional to the horizontal swipe offset")
    }
    
}
