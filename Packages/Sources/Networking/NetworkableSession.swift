//
//  File.swift
//  
//
//  Created by Khoa Le on 22/11/2023.
//

import Foundation

/// An ad-hoc network layer built on `URLSession` to perform an HTTP request.
public protocol NetworkableSession {
    /// Retrieves the contents that is specified by an HTTP request asynchronously.
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    ///   - decoder: An object decodes the data to result from JSON objects.
    /// - Returns: The decoded data.
    func data<T>(
        for request: Request,
        decoder: JSONDecoder
    ) async throws -> T where T: Decodable

    /// Retrieves the contents that is specified by an HTTP request asynchronously.
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    func data(for request: Request) async throws
}
