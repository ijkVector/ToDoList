//
//  URLSession+Extension.swift
//  ToDoList
//
//  Created by Иван Дроботов on 12.07.2024.
//

import Foundation

enum NetworkError: Error {
    case cancelled
    case networkError(Error)
    case unknownError
}

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            guard !Task.isCancelled else {
                continuation.resume(throwing: NetworkError.cancelled)
                return
            }
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let data, let response {
                    continuation.resume(returning: (data, response))
                } else if let error {
                    continuation.resume(throwing: NetworkError.networkError(error))
                } else {
                    continuation.resume(throwing: NetworkError.unknownError)
                }
            }
            task.resume()
        }
    }
}
