//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import Combine


public protocol RequestInterceptor {
    func adapt(request: URLRequest, completion: (URLRequest) -> Void)
}

public protocol NetworkManagerProtocol {
    func execute<T>(request: ApiServiceProvider) -> AnyPublisher<T, Error> where T: Decodable
}

public final class NetworkManager: NSObject, NetworkManagerProtocol {
    private let session: URLSession
    private let interceptor: RequestInterceptor
    private let decoder = JSONDecoder()
    
    public init(configuration: URLSessionConfiguration, interceptor: RequestInterceptor) {
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        self.interceptor = interceptor
        super.init()
    }
    
    public func execute<T>(request: ApiServiceProvider) -> AnyPublisher<T, Error> where T: Decodable {
        guard var request = try? request.returnUrlRequest() else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        interceptor.adapt(request: request) { newRequest in
            request = newRequest
        }
        
        return Deferred {
            self.session.dataTaskPublisher(for: request)
                .mapError { NetworkError.urlSessionError($0) }
                .tryMap { (data, urlResponse) -> T in
                    do {
                        let response = try self.decoder.decode(T.self, from: data) as T
                        return response
                    } catch let error as DecodingError {
                        throw NetworkError.decodingError(error)
                    }
                }
        }.eraseToAnyPublisher()
    }
}
