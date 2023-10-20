//
//  GetCurrenciesUseCase.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import Combine

public protocol GetCurrenciesUseCaseProtocol {
    func execute(currencies: [String]) -> AnyPublisher<GetCurrenciesResponse, Error>
}

struct MockGetCurreciesUseCase: GetCurrenciesUseCaseProtocol {
    func execute(currencies: [String]) -> AnyPublisher<GetCurrenciesResponse, Error>  {
        Future { promise in
            promise(.success(GetCurrenciesResponse(currencies: [
                .init(name: "USD", value: 28),
                .init(name: "EUR", value: 30),
                .init(name: "GBP", value: 19),
            ], updatedAt: Date())))
        }
        .eraseToAnyPublisher()
    }
}

public final class GetCurrenciesUseCase: GetCurrenciesUseCaseProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: WalletRepository
    
    public init(repository: WalletRepository) {
        self.repository = repository
    }
    
    public func execute(currencies: [String]) -> AnyPublisher<GetCurrenciesResponse, Error> {
        repository
            .getCurrencies(request: .init(currencies: currencies))
            .map { self.mapCurrencies($0) }
            .eraseToAnyPublisher()
    }
    
    private func mapCurrencies(_ response: CurrencyListDTO) -> GetCurrenciesResponse {
        let list = response.data.map { CurrencyItem(name: $0.code, value: 1/$0.value) }
        return GetCurrenciesResponse(currencies: list, updatedAt: response.updatedAt)
    }
}
