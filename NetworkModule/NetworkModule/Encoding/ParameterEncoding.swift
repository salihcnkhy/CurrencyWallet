//
//  ParameterEncoding.swift
//  NetworkModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public enum ParameterEncoding {
    case urlEncoding
    
    public func encode(urlRequest: inout URLRequest, parameters: Parameters?) throws {
        
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = parameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            }
            
        } catch {
            throw error
        }
    }
}
