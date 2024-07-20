//
//  FileCacheTests.swift
//  TodoItemTests
//
//  Created by Иван Дроботов on 21.06.2024.
//

//
//  FileCacheTests.swift
//  FileCacheTests
//
//  Created by Иван Дроботов on 21.06.2024.
//

import XCTest

@testable import ToDoList
@testable import FileCacheUtil

final class FileCacheTests: XCTestCase {

    private let fileCache = FileCache<TodoItem>(todoItems: [])
    private let fileNameJSON = "TodoItems.json"
    private let fileNameCSV = "TodoItems.csv"

    var todoItem: TodoItem!
    var todoItem1: TodoItem!
    var todoItem2: TodoItem!

    override func setUp() {
        todoItem = TodoItem(
            text: "task1",
            importance: .low,
            deadline: Date(timeIntervalSince1970: 101),
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 99),
            changedAt: Date(timeIntervalSince1970: 100)
        )

        todoItem1 = TodoItem(
            text: "task1",
            importance: .basic,
            deadline: Date(timeIntervalSince1970: 101),
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 99),
            changedAt: Date(timeIntervalSince1970: 100)
        )

        todoItem2 =  TodoItem(
            text: "task1",
            importance: .basic,
            isDone: true,
            createdAt: Date(timeIntervalSince1970: 100)
        )
    }

    override func tearDown() {
        todoItem = nil
        todoItem1 = nil
        todoItem2 = nil
    }

    // MARK: - Test add
    func testAdd() throws {
        try fileCache.add(item: todoItem)
        try fileCache.add(item: todoItem1)
        try fileCache.add(item: todoItem2)

        XCTAssertEqual(fileCache.todoItems, [todoItem, todoItem1, todoItem2])
    }

    // MARK: - Test remove
    func testRemove() throws {
        try fileCache.add(item: todoItem)
        try fileCache.add(item: todoItem1)
        try fileCache.add(item: todoItem2)

        fileCache.removeItem(by: todoItem2.id)

        XCTAssertEqual(fileCache.todoItems, [todoItem, todoItem1])
    }

    // MARK: - Test save load of JSON
    func testSaveLoadJSON() throws {
        try fileCache.add(item: todoItem)
        try fileCache.add(item: todoItem1)
        try fileCache.add(item: todoItem2)

        try fileCache.save(to: fileNameJSON)
        try fileCache.load(from: fileNameJSON)

        XCTAssertEqual(fileCache.todoItems, [todoItem, todoItem1, todoItem2])
    }

    // MARK: - Test save load of CSV
    func testSaveLoadCSV() throws {
        try fileCache.add(item: todoItem)
        try fileCache.add(item: todoItem1)
        try fileCache.add(item: todoItem2)

        try! fileCache.save(to: fileNameCSV, with: .csv)
        try! fileCache.load(from: fileNameCSV, with: .csv)

        XCTAssertEqual(fileCache.todoItems, [todoItem, todoItem1, todoItem2])

        try! fileCache.save(to: fileNameCSV, with: .csv, by: ";")
        try! fileCache.load(from: fileNameCSV, with: .csv, by: ";")

        XCTAssertEqual(fileCache.todoItems, [todoItem, todoItem1, todoItem2])
    }
}
