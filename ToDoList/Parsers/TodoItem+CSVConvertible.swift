//
//  TodoItem+CSVConvertible.swift
//  ToDoList
//
//  Created by Иван Дроботов on 28.06.2024.
//

import Foundation
import FileCacheUtil

// MARK: - Constants
private extension TodoItem {
    enum Constants {
        static let fieldsOfItem = ["id", "text", "importance", "deadline", "isFinished", "сreationDate", "modifiedDate"]
        static let numOfItemFields = 7
    }
}

// MARK: - Parse CSV
extension TodoItem: CSVConvertible {
    static func parse(csv: Any, with separator: String = ",") -> TodoItem? {
        let pattern = #"(?!\B"[^"]*)\#(separator)(?![^"]*"\B)"#
        guard let csvString = csv as? String,
              let csvArray = TodoItem.split(csv: csvString, with: pattern),
              csvArray.count == Constants.numOfItemFields
        else { return nil }
        let parsedCSV = Dictionary(uniqueKeysWithValues: zip(Constants.fieldsOfItem, csvArray))

        guard let id = parsedCSV["id"],
              let text = parsedCSV["text"],
              let isDone = Bool(parsedCSV["isFinished", default: ""]),
              let сreationTimeInterval = TimeInterval(parsedCSV["сreationDate", default: ""])
        else { return nil }

        let createdAt = Date(timeIntervalSince1970: сreationTimeInterval)
        let importance = (parsedCSV["importance"]).flatMap(Importance.init(rawValue:)) ?? .routine
        let deadline = (TimeInterval(parsedCSV["deadline", default: ""])).flatMap(Date.init(timeIntervalSince1970:))
        let changedAt = (TimeInterval(parsedCSV["modifiedDate", default: ""])).flatMap(Date.init(timeIntervalSince1970:))

        return TodoItem(
            id: id,
            text: TodoItem.removeExtraQuotes(text),
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            createdAt: createdAt,
            changedAt: changedAt
        )
    }

    static func getHeader(with separator: String) -> String {
        Constants.fieldsOfItem.joined(separator: separator)
    }

    func csv(with separator: String = ",") -> String {
        [
            id,
            TodoItem.addExtraQuotes(text),
            importance == .routine ? "" : importance.rawValue,
            deadline?.timeIntervalSince1970.description ?? "",
            "\(isDone)",
            "\(createdAt.timeIntervalSince1970)",
            changedAt?.timeIntervalSince1970.description ?? ""
        ].joined(separator: separator)
    }
}

// MARK: - Private Parse Section
private extension TodoItem {

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

    static func removeExtraQuotes(_ text: String) -> String {
        var text = text
        text.removeFirst()
        text.removeLast()
        return text
    }

    static func addExtraQuotes(_ text: String) -> String {
        "\"\(text)\""
    }
}
