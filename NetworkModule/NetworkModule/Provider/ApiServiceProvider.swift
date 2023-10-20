//
//  ApiServiceProvider.swift
//  NetworkModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
}

protocol URLRequestProtocol {
    func returnUrlRequest() throws -> URLRequest
}

open class ApiServiceProvider: URLRequestProtocol {
    
    private var method: HTTPMethod
    private var path: String?
    private var data: Encodable?
    private let httpPropertyProvider: HttpPropertyProviderProtocol
    
    public init(
        httpPropertyProvider: HttpPropertyProviderProtocol,
        method: HTTPMethod = .get,
        path: String? = nil,
        data: Encodable? = nil) {
            self.httpPropertyProvider = httpPropertyProvider
            self.method = method
            self.path = path
            self.data = data
        }
    
    public func returnUrlRequest() throws -> URLRequest {
        var url = try httpPropertyProvider.getBaseUrl().asURL()
        
        if let path = path {
            url = url.appendingPathComponent(path)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.headers = headers
        
        try configureEncoding(request: &request)
        
        return request
    }
    
    private func configureEncoding(request: inout URLRequest) throws {
        switch method {
        case .get:
            try ParameterEncoding.urlEncoding.encode(urlRequest: &request, parameters: params)
        }
    }
    
    private var params: Parameters? {
        return data?.asDictionary()
    }
    
    private var headers: HTTPHeaders {
        httpPropertyProvider.getHttpHeaders()
    }
}


public protocol HttpPropertyProviderProtocol {
    func getBaseUrl() -> String
    /// use for query params after path like hashed api key etc.
    func getDefaultQueryParams() -> [URLQueryItem]?
    func getHttpHeaders() -> HTTPHeaders
    func getParameterEncoding(by method: HTTPMethod) -> ParameterEncoding
}

public extension HttpPropertyProviderProtocol {
    
    func getDefaultQueryParams() -> [URLQueryItem]? {
        nil
    }
    
    func getHttpHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(.contentTypeJson)
        return headers
    }
    
    func getParameterEncoding(by method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return .urlEncoding
        }
    }
}

public enum NetworkError: Error {
    case invalidURL
    case urlSessionError(Error)
    case decodingError(Error)
}

extension String {
    
    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NetworkError.invalidURL }
        return url
    }
}

extension URLRequest {
    
    public var headers: HTTPHeaders {
        get { allHTTPHeaderFields.map(HTTPHeaders.init) ?? HTTPHeaders() }
        set { allHTTPHeaderFields = newValue.dictionary }
    }
    
}


extension Encodable {
    func asDictionary() -> Parameters {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toJson() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
}

public struct HTTPHeader: Hashable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension HTTPHeader {
    static let contentTypeJson = HTTPHeader(name: "Content-Type", value: "application/json")
}

public struct HTTPHeaders {
    
    private var headers: [HTTPHeader] = []
    
    public init() {}
    
    public init(_ dictionary: [String: String]) {
        self.init()
        
        dictionary.forEach { update(HTTPHeader(name: $0.key, value: $0.value)) }
    }
    
    public mutating func add(_ header: HTTPHeader) {
        update(header)
    }
    
    public mutating func update(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }
    
    public mutating func update(_ header: HTTPHeader) {
        guard let index = headers.firstIndex(of: header) else {
            headers.append(header)
            return
        }
        
        headers.replaceSubrange(index...index, with: [header])
    }
    
    public var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
}
