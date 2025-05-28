import XCTest
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

@testable import HomeKit

final class NotificationViewModelTests: XCTestCase {
    // MARK: Properties
    
    private var mockGetNotificationUsecase: MockGetNotificationUsecase!
    private var sut: NotificationViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockGetNotificationUsecase = MockGetNotificationUsecase()
        sut = .init(context: .init(
            notifications: getMockNotifications(),
            getNotificationsUsecase: mockGetNotificationUsecase))
        cancellables = []
    }

    override func tearDown() {
        mockGetNotificationUsecase = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func test_firstLoadData_Success() {
        // Given
        let expectation = expectation(description: "Wait for loading to complete")
        var loadData = [NotificationModel]()
        
        // When
        sut.$notifications
            .dropFirst()
            .sink {
                loadData = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.firstLoadData()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(loadData.count, 2)
        XCTAssertEqual(loadData[0].isRead, false)
        XCTAssertEqual(loadData[1].isRead, true)
    }
    
    func test_reset_SendFinishOutput() {
        // Given
        let expectation = expectation(description: "Wait for reseting to complete")
        var isFinishCalled = false
        
        // When
        sut.outputPublisher()
            .sink {
                guard case .finish = $0 else { return }
                isFinishCalled = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.reset()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(isFinishCalled)
    }
    
    func test_refreshData_Success() {
        // Given
        let expectation = expectation(description: "Wait for refreshing to complete")
        mockGetNotificationUsecase.results = getMockNotifications()
        
        var loadData = [NotificationModel]()
        
        // When
        sut.$notifications
            .dropFirst()
            .sink { loadData = $0 }
            .store(in: &cancellables)
        
        sut.refreshData { expectation.fulfill() }
        
        // Then
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockGetNotificationUsecase.isExecuted)
        XCTAssertEqual(loadData.count, 2)
        XCTAssertEqual(loadData[0].title, "Transaction")
        XCTAssertEqual(loadData[1].message, "Withdrawed")
    }
    
    func test_refreshData_Failure() {
        // Given
        let expectation = expectation(description: "Wait for refreshing to complete")
        mockGetNotificationUsecase.error = APIError.invalidResponse(statusCode: nil)
        
        var message: String? = String()
        
        // When
        sut.$errorMessage
            .dropFirst()
            .sink { message = $0 }
            .store(in: &cancellables)
        
        sut.refreshData { expectation.fulfill() }
        
        // Then
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockGetNotificationUsecase.isExecuted)
        XCTAssertNotNil(message)
        XCTAssertTrue(!message!.isEmpty)
    }
}

// MARK: Helper

private extension NotificationViewModelTests {
    func getMockNotifications() -> [NotificationModel] {
        [
            .init(isRead: false, lastUpdated: "22/09/02", title: "Transaction", message: "Deposited"),
            .init(isRead: true, lastUpdated: "21/09/02", title: "Transaction", message: "Withdrawed")
        ]
    }
}

// MARK: Mock Use case

private class MockGetNotificationUsecase: GetNotificationsUsecase {
    var results = [NotificationModel]()
    var error: Error?
    var isExecuted = false
    
    func execute() async throws -> [NotificationModel] {
        guard let error else {
            isExecuted = true
            return results
        }
        isExecuted = true
        throw error
    }
}
