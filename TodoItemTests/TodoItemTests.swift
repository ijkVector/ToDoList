//
//  TodoItemTests.swift
//  TodoItemTests
//
//  Created by Иван Дроботов on 20.06.2024.
//

import XCTest

@testable import ToDoList

final class TodoItemTests: XCTestCase {

    var json: Any!
    var todoItem: TodoItem!
    var csv: Any!

    override func setUp() {
        super.setUp()
        todoItem = TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .basic,
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 100),
            changedAt: Date(timeIntervalSince1970: 101)
        )

        json = """
        {
            "id": "todoItem1",
            "text": "task1",
            "importance": "unimportant",
            "deadline": 101,
            "isFinished": true,
            "сreationDate": 100,
        }
        """

        csv = "todoItem1,task1,unimportant,101,true,100,"
    }

    override func tearDown() {
        json = nil
        todoItem = nil
        csv = nil
        super.tearDown()
    }

    // MARK: - Test
    func testConvertJson() throws { // Как лучше тестить ?
        let json1 = todoItem.json
        guard let todoItem1 = TodoItem.parse(json: json1) else {
            XCTFail("Failed to parse json into object")
            return
        }
        XCTAssertEqual(todoItem1, todoItem)
    }

    // MARK: - Test Parse JSON
    func testParseJson() throws {
        // MARK: - Parse JSON without importance, deadline, modifiedDate
        json = """
        {
            "id": "todoItem1",
            "text": "task1",
            "isFinished": true,
            "сreationDate": 100,
        }
        """
        guard let todoItem = TodoItem.parse(json: json!) else {
            XCTFail("Failed to parse json into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .basic)
        XCTAssertEqual(todoItem.deadline, nil)
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Parse JSON without deadline, modifiedDate
        json = """
        {
            "id": "todoItem1",
            "text": "task1",
            "importance": "important",
            "isFinished": true,
            "сreationDate": 100,
        }
        """
        guard let todoItem = TodoItem.parse(json: json!) else {
            XCTFail("Failed to parse json into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .important)
        XCTAssertEqual(todoItem.deadline, nil)
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Parse JSON without modifiedDate
        json = """
        {
            "id": "todoItem1",
            "text": "task1",
            "importance": "unimportant",
            "deadline": 101,
            "isFinished": true,
            "сreationDate": 100,
        }
        """
        guard let todoItem = TodoItem.parse(json: json!) else {
            XCTFail("Failed to parse json into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 101))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Test Parse JSON full
        json = """
        {
            "id": "todoItem1",
            "text": "task1",
            "importance": "unimportant",
            "deadline": 102,
            "isFinished": true,
            "сreationDate": 100,
            "modifiedDate": 101
        }
        """
        guard let todoItem = TodoItem.parse(json: json!) else {
            XCTFail("Failed to parse json into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 102))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt!, Date(timeIntervalSince1970: 101))
    }

    // MARK: - Test Parse CSV
    func testParseCSV() throws {
        // MARK: - Parse CSV without importance, deadline, modifiedDate
        csv = "todoItem1,\"task1\",,,true,100,"
        guard let todoItem = TodoItem.parse(csv: csv!) else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .basic)
        XCTAssertEqual(todoItem.deadline, nil)
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Parse CSV without deadline, modifiedDate
        csv = "todoItem1,\"task1\",important,,true,100,"
        guard let todoItem = TodoItem.parse(csv: csv!) else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .important)
        XCTAssertEqual(todoItem.deadline, nil)
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Parse CSV without modifiedDate
        csv = "todoItem1,\"task1\",unimportant,101,true,100,"
        guard let todoItem = TodoItem.parse(csv: csv!) else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 101))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt, nil)

        // MARK: - Test Parse CSV full
        csv = "todoItem1,\"task1\",unimportant,102,true,100,101"
        guard let todoItem = TodoItem.parse(csv: csv!) else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "task1")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 102))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt!, Date(timeIntervalSince1970: 101))

        // MARK: - Test Parse CSV with commas inside quotes
        csv = "todoItem1,\"Hello, World,\",unimportant,102,true,100,101"
        guard let todoItem = TodoItem.parse(csv: csv!) else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "Hello, World,")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 102))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt!, Date(timeIntervalSince1970: 101))

        // MARK: - Test Parse with with another separator
        csv = "todoItem1;\"Hello; World,\";unimportant;102;true;100;101"
        guard let todoItem = TodoItem.parse(csv: csv!, with: ";") else {
            XCTFail("Failed to parse csv into object")
            return
        }
        XCTAssertEqual(todoItem.id, "todoItem1")
        XCTAssertEqual(todoItem.text, "Hello; World,")
        XCTAssertEqual(todoItem.importance, .low)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 102))
        XCTAssertEqual(todoItem.isDone, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changedAt!, Date(timeIntervalSince1970: 101))
    }

    // MARK: - Test Convert to CSV
    func testConvertToCSV() throws {
        // MARK: - with .routine, without deadline and modifiedDate
        todoItem = TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .basic,
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(todoItem.csv(), "todoItem1,\"task1\",,,true,100.0,")

        // MARK: - without deadline and modifiedDate
        todoItem =  TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .important,
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(todoItem.csv(), "todoItem1,\"task1\",important,,true,100.0,")

        // MARK: - without modifiedDate
        todoItem =  TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 101),
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(todoItem.csv(), "todoItem1,\"task1\",important,101.0,true,100.0,")

        // MARK: - with all fields
        todoItem = TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 101),
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 99),
            changedAt: Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(todoItem.csv(), "todoItem1,\"task1\",important,101.0,true,99.0,100.0")

        // MARK: - with another separator
        todoItem = TodoItem(
            id: "todoItem1",
            text: "task1",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 101),
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 99),
            changedAt: Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(todoItem.csv(with: ";"), "todoItem1;\"task1\";important;101.0;true;99.0;100.0")
    }
}
