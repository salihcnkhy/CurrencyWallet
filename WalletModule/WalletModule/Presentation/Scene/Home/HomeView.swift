//
//  HomeView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    private let routeCallback: Route<HomeRoute>
    
    public init(viewModel: HomeViewModel, routeCallback: @escaping Route<HomeRoute>) {
        self.viewModel = viewModel
        self.routeCallback = routeCallback
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            UserInformationHeaderView(
                fullName: viewModel.fullName,
                wallets: viewModel.wallets,
                hasError: viewModel.userInformationHasError,
                selectedWallet: $viewModel.selectedWallet,
                selectWalletAction: { code in
                    viewModel.selectWallet(code)
                })
            .zIndex(1)
            
            Group {
                ScrollView(showsIndicators: false) {
                    CurrencyListView(
                        currencies: viewModel.currencies,
                        onBuyButtonPressed: { currency in
                            routeCallback(.buyCurrency(currency))
                        }
                    )
                    .padding(.top, 20)
                    
                    if !viewModel.lastUpdateDate.isEmpty {
                        LocalizedText(key: .updateTime(viewModel.lastUpdateDate))
                            .font(.caption)
                            .foregroundStyle(.clPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Group {
                    RoundedButtonView(title: .addMoney, action: {
                        viewModel.addMoney()
                    })
                    RoundedButtonView(title: .transactionHistory, action: {
                        routeCallback(.history)
                    })
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
            .padding(.horizontal, 10)
            
        }
        .onAppear {
            viewModel.fetchUser()
            viewModel.fetchCurrencies()
        }
        .onChange(of: viewModel.wallets, perform: { newValue in
            print(newValue)
        })
        .padding(.bottom, 20)
        .navigationBarHidden(true)
        .background(Color.clBackground)
    }
}

#Preview {
    HomeView(viewModel: .init(getCurrenciesUseCase: MockGetCurreciesUseCase(), getUserInformationUseCase: MockGetUserInformationUseCase(), appendTurkishLiraUseCase: MockAppendTurkishLiraUseCase()), routeCallback: { _ in })
}
