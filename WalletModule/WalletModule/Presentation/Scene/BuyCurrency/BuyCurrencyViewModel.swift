//
//  BuyCurrencyViewModel.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import SwiftUI
import Combine

public final class BuyCurrencyViewModel: ObservableObject {
    let currency: Currency
    private let buyCurrencyUseCase: BuyCurrencyUseCaseProtocol
    private var anyCancellables = Set<AnyCancellable>()
    private var focusedTextField: FocusedTextField? = nil
    
    @Published var liraAmount: String = ""
    @Published var currencyAmount: String = ""
    @Published var isCompleted: Bool = false
    @Published var errorString: LocalizedKeys? = nil
    @Published var dismissView: Bool = false
    @Published var isTryingToBuy: Bool = false
    var currencyTextFieldFormatter: TitledCurrencyTextFieldFormatterProtocol
    
    public init(currency: Currency, buyCurrencyUseCase: BuyCurrencyUseCaseProtocol) {
        self.currency = currency
        self.buyCurrencyUseCase = buyCurrencyUseCase
        self.currencyTextFieldFormatter = TitledCurrencyTextFieldFormatter()
        bindAmounts()
    }
    
    private func bindAmounts() {
        $liraAmount.sink { [weak self] value in
            guard let self else { return }
            guard let focusedTextField, focusedTextField == .lira else { return }
            
            guard !value.isEmpty else {
                self.currencyAmount = ""
                return
            }
            
            guard let liraAmount = NumberFormatter.moduleFormatter.number(from: value)?.doubleValue else { return }
            
            guard liraAmount != 0 else {
                self.currencyAmount = ""
                return
            }
            
            let currencyAmount =  NSNumber(value: liraAmount / self.currency.rate)
            guard let newCurrencyString = NumberFormatter.moduleFormatter.string(from: currencyAmount) else { return }
            self.currencyAmount = newCurrencyString
        }.store(in: &anyCancellables)
        
        $currencyAmount.sink { [weak self] value in
            guard let self else { return }
            guard let focusedTextField, focusedTextField == .currency else { return }
            
            guard !value.isEmpty else {
                self.liraAmount = ""
                return
            }
            
            guard let currencyAmount = NumberFormatter.moduleFormatter.number(from: value)?.doubleValue else { return }
            
            guard currencyAmount != 0 else {
                self.liraAmount = ""
                return
            }
            
            let liraAmount = NSNumber(value: currencyAmount * self.currency.rate)
            guard let newLiraString = NumberFormatter.moduleFormatter.string(from: liraAmount) else { return }
            self.liraAmount = newLiraString
        }.store(in: &anyCancellables)
    }
    
    func getLocalizedCurrencyName() -> String {
        // TODO: -remove- Prefix currency_ !!
        let currencyName = String(localized: .init(String("currency_"+currency.information.name)), bundle: .walletModule)
        return currencyName
    }
    
    func buyCurrency() {
        guard let liraAmount = NumberFormatter.moduleFormatter.number(from: liraAmount)?.doubleValue else { return }
        guard let currencyAmount = NumberFormatter.moduleFormatter.number(from: currencyAmount)?.doubleValue else { return }
        isTryingToBuy = true
        buyCurrencyUseCase.execute(curencyAmount: currencyAmount, liraAmount: liraAmount, for: currency.information.code) { [weak self] result in
            
            switch result {
            case .success(_):
                withAnimation {
                    self?.isCompleted = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.dismissView = true
                }
            case .failure(let error):
                self?.errorString = switch error {
                case .walletNotFound:
                    .addMoney
                case .walletBalanceNotEnough:
                    .notEnoughLiraBalance
                case .unknown:
                    .generalError
                }
                
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.errorString = nil
                    }
                   
                    self?.isTryingToBuy = false
                }
            }
        }
    }
    
    func setFocused(_ type: FocusedTextField) {
        focusedTextField = type
    }
    
    enum FocusedTextField {
        case lira
        case currency
    }
}
