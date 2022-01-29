//
//  APIError.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-23.
//

import Foundation

enum APIError: Error {
    case failedRequest
    case unexpectedDataFormat
    case failedResponse
}

