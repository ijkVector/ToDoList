//
//  NetworkingServiceProtocol.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

protocol NetworkingServiceProtocol {
    func getItemList(completion: @escaping (Result<NetworkTodoListModel, NetworkingServiceError>) -> Void)
    func updateItemList(modelsList: [TodoItem], revision: Int32, completion: @escaping (Result<NetworkTodoListModel, NetworkingServiceError>) -> Void)
    func getItemtBy(id: TodoItem.ID, completion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void)
    func append(item: TodoItem, comletion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void)
    func chageItemBy(id: TodoItem.ID, item: TodoItem, comletion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void)
    func removeItemBy(id: TodoItem.ID, completion: @escaping (Result<NetworkTodoElementModel, NetworkingServiceError>) -> Void)
}
