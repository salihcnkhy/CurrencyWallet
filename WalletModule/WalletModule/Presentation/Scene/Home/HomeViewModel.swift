//
//  WalletViewModel.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import SwiftUI
import Combine

public enum CurrencyType: CaseIterable {
    case tl
    case usd
    case euro
    case pound
    case rub
    case cny
    
    init?(rawValue: String) {
        switch rawValue {
        case "TRY":
            self = .tl
        case "USD":
            self = .usd
        case "EUR":
            self = .euro
        case "GBP":
            self = .pound
        case "RUB":
            self = .rub
        case "CNY":
            self = .cny
        default:
            return nil
        }
    }
}

struct CurrencyPropertyFactory {
    func create(with type: CurrencyType) -> CurrencyInformation {
        switch type {
        case .tl:
            CurrencyInformation(
                flagIcon: .init(.icFlagTurkey),
                name: .init("tl"),
                sign: .init(position: .right, value: "₺"),
                code: "TRY")
        case .usd:
            CurrencyInformation(
                flagIcon: .init(.icFlagUnitedStates),
                name: .init("dollar"),
                sign: .init(position: .left, value: "$"),
                code: "USD")
        case .euro:
            CurrencyInformation(
                flagIcon: .init(.icFlagEuropeanUnion),
                name: .init("euro"),
                sign: .init(position: .left, value: "€"),
                code: "EUR")
        case .pound:
            CurrencyInformation(
                flagIcon: .init(.icFlagUnitedKingdom),
                name: .init("pound"),
                sign: .init(position: .left, value: "£"),
                code: "GBP")
        case .rub:
            CurrencyInformation(
                flagIcon: .init(.icFlagRussia),
                name: .init("rub"),
                sign: .init(position: .right, value: "₽"),
                code: "RUB")
        case .cny:
            CurrencyInformation(
                flagIcon: .init(.icFlagChina),
                name: .init("cny"),
                sign: .init(position: .right, value: "¥"),
                code: "CNY")
        }
    }
}


public struct CurrencyInformation {
    public let flagIcon: Image
    public let name: String
    public let sign: Sign
    public let code: String
    
    public struct Sign {
        let position: Position
        let value: String
        
        enum Position {
            case left
            case right
        }
    }
}

public struct Currency: Identifiable {
    public let id = UUID()
    public let information: CurrencyInformation
    public let rate: Double
    public let trend: CurrencyTrend
}

public enum CurrencyTrend {
    case up, down
}

public final class HomeViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var wallets: [VirtualWallet] = []
    @Published var selectedWallet: VirtualWallet? = nil
    @Published var currencies: [Currency] = []
    @Published var lastUpdateDate: String = ""
    @Published var userInformationHasError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let getCurrenciesUseCase: GetCurrenciesUseCaseProtocol
    private let getUserInformationUseCase: GetUserInformationUseCaseProtocol
    private let appendTurkishLiraUseCase: AppendTurkishLiraUseCaseProtocol
    
    public init(
        getCurrenciesUseCase: GetCurrenciesUseCaseProtocol,
        getUserInformationUseCase: GetUserInformationUseCaseProtocol,
        appendTurkishLiraUseCase: AppendTurkishLiraUseCaseProtocol
    ) {
        self.getCurrenciesUseCase = getCurrenciesUseCase
        self.getUserInformationUseCase = getUserInformationUseCase
        self.appendTurkishLiraUseCase = appendTurkishLiraUseCase
    }
    
    func fetchCurrencies() {
        getCurrenciesUseCase
            .execute(currencies: CurrencyType.allCases.map { CurrencyPropertyFactory().create(with: $0).code }.filter { $0 != "TRY" })
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] response in
                self?.updateCurrencies(response)
            })
            .store(in: &cancellables)
    }
    
    func fetchUser() {
        getUserInformationUseCase
            .execute()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(_):
                    self?.userInformationHasError = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] walletResponse in
                self?.fullName = walletResponse.user.fullName
                self?.wallets = walletResponse.user.wallets
                self?.selectedWallet = walletResponse.user.wallets.first // TODO: Wallet yoksa eğer bi error handling
            }
            .store(in: &cancellables)
        
        
        getUserInformationUseCase.subscibeWalletUpdates().sink { [weak self] wallet in
            self?.updateWallet(with: wallet)
        }
        .store(in: &cancellables)
    }
    
    func selectWallet(_ code: String) {
        guard let wallet = wallets.first(where: { $0.currencyCode == code }) else {
            return
        }
        
        withAnimation {
            selectedWallet = wallet
        }
    }
    
    private func updateCurrencies(_ response: GetCurrenciesResponse) {
        DispatchQueue.main.async {
            self.lastUpdateDate = self.formatLastUpdateDate(response.updatedAt)
            self.currencies = response.currencies.compactMap { currencyItem -> Currency? in
                guard let type = CurrencyType(rawValue: currencyItem.name) else { return nil }
                return Currency(
                    information: CurrencyPropertyFactory().create(with: type),
                    rate: currencyItem.value,
                    trend: .up
                )
            }
        }
    }
    
    private func updateWallet(with wallet: VirtualWallet) {
        guard let index = wallets.firstIndex(where: { $0.id == wallet.id }) else { return }

        DispatchQueue.main.async {
            self.wallets[index] = wallet
            if self.selectedWallet?.id == wallet.id {
                self.selectedWallet = wallet
            }
        }
    }
    
    private func formatLastUpdateDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func addMoney() {
        if let tryWallet = wallets.first(where: { $0.currencyCode == "TRY" }) {
            withAnimation {
                selectedWallet = tryWallet
            }
        }
        
        appendTurkishLiraUseCase.appendTurkishLira()
    }
}
