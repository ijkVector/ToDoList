//
//  TodoItem.swift
//  ToDoList
//
//  Created by Иван Дроботов on 20.06.2024.
//

import Foundation

enum Importance: String {
    case unimportant
    case routine
    case important
}

//MARK: - TodoItem Defenition
struct TodoItem: Equatable {
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isFinished: Bool
    let сreationDate: Date
    let modifiedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isFinished: Bool = false,
        сreationDate: Date = Date(),
        modifiedDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isFinished = isFinished
        self.сreationDate = сreationDate
        self.modifiedDate = modifiedDate
    }
}

//MARK: - Parse JSON
extension TodoItem: JSONConvertible {
    //MARK: - From Json to TodoItem
    static func parse(json: Any) -> TodoItem? {
        guard let jsonAsString = json as? String else { return nil } //Можно ли сократить ?
        let jsonData = Data(jsonAsString.utf8)
        
        guard let jsonAsDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let id = jsonAsDictionary["id"] as? String,
              let text = jsonAsDictionary["text"] as? String,
              let isFinished = jsonAsDictionary["isFinished"] as? Bool,
              let сreationTimeInterval = jsonAsDictionary["сreationDate"] as? TimeInterval
        else { return nil }
        
        let сreationDate = Date(timeIntervalSince1970: сreationTimeInterval)
        let importance = (jsonAsDictionary["importance"] as? String).flatMap(Importance.init(rawValue:)) ?? .routine
        let deadline = (jsonAsDictionary["deadline"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        let modifiedDate = (jsonAsDictionary["modifiedDate"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            сreationDate: сreationDate,
            modifiedDate: modifiedDate
        )
    }
    
    //MARK: - From TodoItme to Json
    var json: Any { 
        var dict = [String: Any]()
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = importance == .routine ? nil : importance.rawValue
        dict["deadline"] = deadline == nil ? nil : deadline?.timeIntervalSince1970
        dict["isFinished"] = isFinished
        dict["сreationDate"] = сreationDate.timeIntervalSince1970
        dict["modifiedDate"] = modifiedDate == nil ? nil : modifiedDate?.timeIntervalSince1970
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

//MARK: - Parse CSV
extension TodoItem: CSVConvertible {
    static func parse(csv: Any, with separator: String = ",") -> TodoItem? {
        let pattern = #"(?!\B"[^"]*)\#(separator)(?![^"]*"\B)"#
        guard let csvString = csv as? String,
              let csvArray = TodoItem.split(csv: csvString, with: pattern),
              csvArray.count == Constants.numOfItemFields
        else { return nil }
        let parsedCSV = Dictionary(uniqueKeysWithValues: zip(Constants.fieldsOfItem, csvArray))
        
        guard let id = parsedCSV["id"],
              var text = parsedCSV["text"],
              let isFinished = Bool(parsedCSV["isFinished", default: ""]),
              let сreationTimeInterval = TimeInterval(parsedCSV["сreationDate", default: ""])
        else { return nil }
        
        text.removeFirst()
        text.removeLast()
        let сreationDate = Date(timeIntervalSince1970: сreationTimeInterval)
        let importance = (parsedCSV["importance"]).flatMap(Importance.init(rawValue:)) ?? .routine
        let deadline = (TimeInterval(parsedCSV["deadline", default: ""])).flatMap(Date.init(timeIntervalSince1970:))
        let modifiedDate = (TimeInterval(parsedCSV["modifiedDate", default: ""])).flatMap(Date.init(timeIntervalSince1970:))
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            сreationDate: сreationDate,
            modifiedDate: modifiedDate
        )
    }
    
    static func getHeader(with separator: String) -> String {
        Constants.fieldsOfItem.joined(separator: separator)
    }
    
    func csv(with separator: String = ",") -> String {
        [
            id,
            "\"\(text)\"",
            importance == .routine ? "" : importance.rawValue,
            deadline?.timeIntervalSince1970.description ?? "",
            "\(isFinished)",
            "\(сreationDate.timeIntervalSince1970)",
            modifiedDate?.timeIntervalSince1970.description ?? "",
        ].joined(separator: separator)
    }
}

//MARK: - Private Section
private extension TodoItem {
    
    enum Constants {
        static let fieldsOfItem = ["id", "text", "importance", "deadline", "isFinished", "сreationDate", "modifiedDate"]
        static let numOfItemFields = 7
    }
    
    static func split(csv: String, with pattern: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let nsCSV = csv as NSString
        let ranges = regex.matches(in: csv, range: NSRange(location: 0, length: nsCSV.length))
            .map { $0.range }
        
        var currentStartIndex = 0
        var partition = ranges
            .reduce(into: [String]()) { partialResult, range in
                let column = nsCSV.substring(with: NSRange(location: currentStartIndex, length: range.location-currentStartIndex))
                partialResult.append(column)
                currentStartIndex = range.location + range.length
            }
        
        if nsCSV.length > 0 && ranges.last?.location == nsCSV.length-1 {
            partition.append("")
        }
        
        if currentStartIndex < nsCSV.length {
            partition.append(nsCSV.substring(with: NSRange(location: currentStartIndex, length: nsCSV.length - currentStartIndex)))
        }
        
        return partition
    }
}
