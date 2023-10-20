//
//  CurrencyApiInterceptor.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import NetworkModule

struct CurrencyApiInterceptor: RequestInterceptor {
    private let apiKey = "cur_live_C77eFktjzFQsxLQN7M5AZYVeUaDpCCFnUfIy4QO7"
    
    func adapt(request: URLRequest, completion: (URLRequest) -> Void) {
        var adaptedRequest = request
          
          guard let url = request.url else {
              completion(adaptedRequest)
              return
          }
          
          var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
          let apiKeyQueryItem = URLQueryItem(name: "apikey", value: apiKey)
        
          if components?.queryItems != nil {
              components?.queryItems?.append(apiKeyQueryItem)
          } else {
              components?.queryItems = [apiKeyQueryItem]
          }
          
          adaptedRequest.url = components?.url
          
         completion(adaptedRequest)
    }
}
