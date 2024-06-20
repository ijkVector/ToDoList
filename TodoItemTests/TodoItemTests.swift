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
            importance: .unimportant,
            deadline: Date(timeIntervalSince1970: 102),
            isFinished: true,
            сreationDate: Date(timeIntervalSince1970: 100),
            modifiedDate: Date(timeIntervalSince1970: 101)
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
        
        csv = "todoItem1,task1,unimportant,101,true,100,nil"
    }
    
    func testConvertToJson() throws {
        let todoItemAsJson = todoItem.json
        guard let jsonStirngItem = todoItemAsJson as? String,
              let jsonString = json as? String
        else {
            XCTFail("Failed to parse object into json")
            return
        }
        
    }
    
    func testParseJson() throws {
        //MARK: - Parse JSON without importance, deadline, modifiedDate
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
        XCTAssertEqual(todoItem.importance, .routine)
        XCTAssertEqual(todoItem.deadline, nil)
        XCTAssertEqual(todoItem.isFinished, true)
        XCTAssertEqual(todoItem.сreationDate, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.modifiedDate, nil)
        
        //MARK: - Parse JSON without deadline, modifiedDate
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
        XCTAssertEqual(todoItem.isFinished, true)
        XCTAssertEqual(todoItem.сreationDate, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.modifiedDate, nil)
        
        //MARK: - Parse JSON without modifiedDate
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
        XCTAssertEqual(todoItem.importance, .unimportant)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 101))
        XCTAssertEqual(todoItem.isFinished, true)
        XCTAssertEqual(todoItem.сreationDate, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.modifiedDate, nil)
        
        //MARK: - Test Parse JSON full
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
        XCTAssertEqual(todoItem.importance, .unimportant)
        XCTAssertEqual(todoItem.deadline!, Date(timeIntervalSince1970: 102))
        XCTAssertEqual(todoItem.isFinished, true)
        XCTAssertEqual(todoItem.сreationDate, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.modifiedDate!, Date(timeIntervalSince1970: 101))
    }
}

