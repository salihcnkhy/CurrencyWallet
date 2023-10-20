//
//  CurrencyRemoteAdapter.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import WalletModule
import NetworkModule
import Combine
import RealmSwift

final class GetCurrencyServiceProvider: ApiServiceProvider {
    init(httpPropertyProvider: HttpPropertyProviderProtocol, request: GetCurrencyRequest) {
        super.init(httpPropertyProvider: httpPropertyProvider, method: .get, path: nil, data: request)
    }
}

struct CurrencyRemoteAdapter: CurrencyRemoteAdapterProtocol, GetResolver {
    private let apiManager: NetworkManagerProtocol
    private let synchronizer: CurrencySynchronizerProtocol
    
    init(apiManager: NetworkManagerProtocol, synchronizer: CurrencySynchronizerProtocol) {
        self.apiManager = apiManager
        self.synchronizer = synchronizer
    }
    
    func syncCurrencies(request: GetCurrencyRequest) -> AnyPublisher<CurrencyListDTO, Error> {
        synchronizer.setRequest(request: request)
        return synchronizer.publisher
    }
}

protocol CurrencySynchronizerProtocol {
    var publisher: AnyPublisher<CurrencyListDTO, Error> { get }
    func setRequest(request: GetCurrencyRequest)
}

final class CurrencySynchronizer: CurrencySynchronizerProtocol, GetResolver {
    private let currencySubject = CurrentValueSubject<CurrencyListDTO?, Error>(nil)
    private let apiManager: NetworkManagerProtocol
    private let currencyLocalManager: CurrencyLocalStorageManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private var request: GetCurrencyRequest?
    
    init(apiManager: NetworkManagerProtocol, currencyLocalManager: CurrencyLocalStorageManagerProtocol) {
        self.apiManager = apiManager
        self.currencyLocalManager = currencyLocalManager
        getInitialData()
        startTimer()
    }
    
    var publisher: AnyPublisher<CurrencyListDTO, Error> {
        currencySubject
            .compactMap { $0 }
            .share()
            .eraseToAnyPublisher()
    }
    
    func setRequest(request: GetCurrencyRequest) {
        self.request = request
        tryUpdate()
    }
    
    private let timePublisher = Timer.publish(every: 300, on: .main, in: .common)
        .autoconnect()
    
    private func getInitialData() {
        let result = currencyLocalManager.getCurrencies()
        
        switch result {
        case .success(let data):
            currencySubject.send(data)
        case .failure(_):
            break
        }
    }
    
    private func startTimer() {
        timePublisher.sink { [weak self] _ in
            self?.tryUpdate()
        }
        .store(in: &cancellables)
    }
    
    private func tryUpdate() {
        guard let request = request else {
            return
        }
        
        let provider = returnResolver().resolve(GetCurrencyServiceProvider.self, argument: request)!
        apiManager
            .execute(request: provider)
            .sink { _ in
                
            } receiveValue: { [weak self] (response: CurrencyListDTO) in
                self?.currencyLocalManager.saveCurrencies(response)
                self?.currencySubject.send(response)
            }
            .store(in: &cancellables)
    }
}

protocol CurrencyLocalStorageManagerProtocol {
    func getCurrencies() -> Result<CurrencyListDTO, Error>
    func saveCurrencies(_ currencyList: CurrencyListDTO)
}

struct CurrencyLocalStorageManager: CurrencyLocalStorageManagerProtocol {
    private let realmManager: RealmManagerProtocol
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    func getCurrencies() -> Result<CurrencyListDTO, Error> {
        guard let object =  realmManager.read(ofType: CurrencyObject.self, keyType: "currency") else {
            return .failure(NSError(domain: "notFound", code: 0))
        }
        
        let items = Array(object.currencies.compactMap {
            CurrencyItemDTO(code: $0.code, value: $0.rate)
        })
        
        return .success(CurrencyListDTO(data: items, updatedAt: object.updateDate))
    }
    
    func saveCurrencies(_ currencyList: CurrencyListDTO) {
        let list = currencyList.data.map { CurrencyItemObject(code: $0.code, rate: $0.value) }
        let date = currencyList.updatedAt
        
        let currencyObject = CurrencyObject(currencies: list, updateDate: date)
        realmManager.write(operation: .add(currencyObject, .modified), completion: nil)
    }
}
