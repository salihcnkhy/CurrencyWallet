//
//  BuyCurrencyView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

public struct BuyCurrencyView: View {
    
    @ObservedObject var viewModel: BuyCurrencyViewModel
    @FocusState var liraFocused: Bool
    @FocusState var currencyFocused: Bool
    private let onCompleted: () -> Void
    
    public init(viewModel: BuyCurrencyViewModel, onCompleted: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onCompleted = onCompleted
    }
    
    public var body: some View {
        ZStack {
            VStack {
                LocalizedText(key: .addMoney)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        viewModel.currency
                            .information
                            .flagIcon
                            .resizable()
                            .frame(width: 80, height: 80)
                        
                        CurrencyTrendView(currency: viewModel.currency)
                            .font(.largeTitle.weight(.medium))
                        
                        TitledCurrencyTextField(
                            titleKey: .currencyAmountWouldLikeToBuyTitle(
                                viewModel.getLocalizedCurrencyName()
                            ),
                            input: $viewModel.currencyAmount,
                            focusState: _currencyFocused)
                        
                        TitledCurrencyTextField(
                            titleKey: .totalAmountOfCurrencyAsTL,
                            input: $viewModel.liraAmount,
                            focusState: _liraFocused)
                        
                        RoundedButtonView(title: .buy, action: {
                            viewModel.buyCurrency()
                            liraFocused = false
                            currencyFocused = false
                        }, disableProvider: {
                            viewModel.isTryingToBuy
                        })
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                    }
                }
                .onChange(of: liraFocused, perform: { value in
                    guard value else { return }
                    viewModel.setFocused(.lira)
                })
                .onChange(of: currencyFocused, perform: { value in
                    guard value else { return }
                    viewModel.setFocused(.currency)
                })
                .onChange(of: viewModel.dismissView, perform: { value in
                    guard value else { return }
                    onCompleted()
                })
            }
            
            if viewModel.isCompleted {
                LocalizedText(key: .transactionCompleted)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .frame(height: 200)
                    .background(.clSecondary.opacity(0.75))
                    .cornerRadius(12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .background(.clBackground)
        .navigationBarHidden(true)
    }
}

#Preview {
    BuyCurrencyView(viewModel: .init(currency: .init(information: CurrencyPropertyFactory().create(with: .usd), rate: 233.234, trend: .up), buyCurrencyUseCase: MockBuyCurrencyUseCase()), onCompleted: {})
}
