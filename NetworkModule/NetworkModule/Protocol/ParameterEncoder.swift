//
//  ParameterEncoder.swift
//  NetworkModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
