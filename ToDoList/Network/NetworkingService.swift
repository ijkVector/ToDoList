//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

import Foundation
import CocoaLumberjackSwift

typealias Header = [String: String]

enum NetworkingServiceError: Error {
    case wrongRequest
    case parsingError
    case elementDoesntExist
    case serverError
    case autoresationError
    case incorrectURL
}

enum Request: String {
    case GET
    case PATCH
    case POST
    case PUT
    case DELETE
}

final class NetworkingService: NetworkingServiceProtocol {
    private var currentRevision: Int32 = 0

    func getItemList(completion: @escaping (Result<NetworkTodoListModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                let request = try await constructRequest(
                    url: NetworkConstants.todoListURL,
                    method: .GET,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token,
                        NetworkConstants.lastRevision: currentRevision.description
                    ]
                )
                await sendRequest(request: request) { (result: Result<NetworkTodoListModel, NetworkingServiceError>) in
                    switch result {
                    case .success(let respones):
                        self.currentRevision = respones.revision
                        completion(.success(respones))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error as! NetworkingServiceError))
            }
        }
    }

    func updateItemList(modelsList: [TodoItem], revision: Int32, completion: @escaping (Result<NetworkTodoListModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                var request = try await constructRequest(
                    url: NetworkConstants.todoListURL,
                    method: .PATCH,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token,
                        NetworkConstants.lastRevision: currentRevision.description,
                        NetworkConstants.jsonType: NetworkConstants.contentType
                    ]
                )
                let networkList = modelsList.map { NetworkTodoItem(modelItem: $0) }
                let body = try JSONEncoder().encode(networkList)
                request.httpBody = body
                await sendRequest(request: request, completion: completion)
            } catch {
                if let error = error as? NetworkingServiceError {
                    completion(.failure(error))
                } else {
                    completion(.failure(.parsingError))
                }
            }
        }
    }

    func getItemtBy(id: TodoItem.ID, completion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                let request = try await constructRequest(
                    url: "\(NetworkConstants.todoListURL)/\(id)",
                    method: .GET,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token
                    ]
                )
                await sendRequest(request: request, completion: completion)
            } catch {
                completion(.failure(.incorrectURL))
            }

        }
    }

    func append(item: TodoItem, comletion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                var request = try await constructRequest(
                    url: NetworkConstants.todoListURL,
                    method: .PATCH,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token,
                        NetworkConstants.lastRevision: currentRevision.description,
                        NetworkConstants.jsonType: NetworkConstants.contentType
                    ]
                )
                let networkItem = NetworkTodoItem(modelItem: item)
                let body = try JSONEncoder().encode(networkItem)
                request.httpBody = body
                await sendRequest(request: request, completion: comletion)
            } catch {
                if let error = error as? NetworkingServiceError {
                    comletion(.failure(error))
                } else {
                    comletion(.failure(.parsingError))
                }
            }
        }
    }

    func chageItemBy(id: TodoItem.ID, item: TodoItem, comletion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                var request = try await constructRequest(
                    url: "\(NetworkConstants.todoListURL)/\(id)",
                    method: .PUT,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token,
                        NetworkConstants.lastRevision: currentRevision.description,
                        NetworkConstants.jsonType: NetworkConstants.contentType
                    ]
                )
                let networkItem = NetworkTodoItem(modelItem: item)
                let body = try JSONEncoder().encode(networkItem)
                request.httpBody = body
                await sendRequest(request: request, completion: comletion)
            } catch {
                if let error = error as? NetworkingServiceError {
                    comletion(.failure(error))
                } else {
                    comletion(.failure(.parsingError))
                }
            }

        }
    }

    func removeItemBy(id: TodoItem.ID, completion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void) {
        Task {
            do {
                let request = try await constructRequest(
                    url: "\(NetworkConstants.todoListURL)/\(id)",
                    method: .DELETE,
                    headers: [
                        NetworkConstants.authorization: NetworkConstants.token
                        ]
                )
                await sendRequest(request: request, completion: completion)
            } catch {
                completion(.failure(.wrongRequest))
            }
        }
    }
}

private extension NetworkingService {
    func constructRequest(url: String, method: Request, headers: Header? = nil) async throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw NetworkingServiceError.incorrectURL
        }
        var request = URLRequest(url: url)
        if let headers {
            for (key, val) in headers {
                request.setValue(val, forHTTPHeaderField: key)
            }
        }
        return request
    }

    func sendRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkingServiceError>) -> Void) async {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse, let error = handelError(response: response) {
                completion(.failure(error))
            }
            let model = try JSONDecoder().decode(T.self, from: data)
            completion(.success(model))
        } catch {
            print(error.localizedDescription)
            await ecsponentialRetry(request: request, completion: completion)
        }
    }

    func ecsponentialRetry<T: Codable>(
        request: URLRequest,
        completion: @escaping (Result<T, NetworkingServiceError>) -> Void,
        minDelay: Double = 2,
        maxDelay: Double = 120,
        factor: Double = 1.5,
        jitter: Double = 0.05
    ) async {
        var delay = minDelay
        while delay < maxDelay {
            let rand = Double.random(in: 0.01...jitter)
            delay = min(delay * (factor + rand), maxDelay)
            await sendRequest(request: request, completion: completion)
            sleep(UInt32(delay))
        }
        completion(.failure(NetworkingServiceError.wrongRequest))
    }

    func handelError(response: HTTPURLResponse) -> NetworkingServiceError? {
        switch response.statusCode {
        case 400:
            return NetworkingServiceError.wrongRequest
        case 401:
            return NetworkingServiceError.autoresationError
        case 404:
            return NetworkingServiceError.elementDoesntExist
        case 500:
            return NetworkingServiceError.serverError
        default:
            return nil
        }
    }
}
