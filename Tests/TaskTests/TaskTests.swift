import XCTest
@testable import Task

final class TaskTests: XCTestCase {
    func testDeps() throws {
		var result: [Int] = []
		Task().deps {
			Task {
				result.append(1)
			}
			Task {
				result.append(2)
			}.deps {
				Task {
					result.append(3)
				}.deps {
					Task {
						result.append(4)
					}
				}
				Task {
					result.append(5)
				}
			}
			Task {
				result.append(6)
			}.deps {
				Task {
					result.append(7)
				}.deps {
					Task {
						result.append(8)
					}
				}
				Task {
					result.append(9)
				}
			}
		}.commit()

		XCTAssertEqual(result, [1, 4, 3, 5, 2, 8, 7, 9, 6])
    }

	func testTask() throws {
		var result: [Int] = []
		Task {
			result.append(1)
		}.commit()
		XCTAssertEqual(result, [1])
	}

	func testNoCommit() throws {
		var result: [Int] = []
		_ = Task {
			result.append(1)
		}
		XCTAssertNotEqual(result, [1])
		XCTAssertEqual(result, [])
	}
}
