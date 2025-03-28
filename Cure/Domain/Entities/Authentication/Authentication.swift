//
//  AuthenticationError.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 18/03/25.
//

enum AuthenticationError: Error {
    case invalidCredentials
    case networkFailure
    case usernameAlreadyExist
    case weakPassword
    case serverError(String)
    case unknownError
}
