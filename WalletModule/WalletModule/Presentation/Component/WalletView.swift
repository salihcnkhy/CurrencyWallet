//
//  WalletView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import SwiftUI

struct WalletView: View {
    var virtualWallets: [VirtualWallet]
    var selectedWallet: VirtualWallet
    var selectWalletAction: (String) -> Void
    @State private var isWalletSelectionShowing = false
    @State private var isCopyWalletIdShowing = false
    
    var body: some View {
        HStack {
            BalanceTextView(code: selectedWallet.currencyCode, balance: selectedWallet.balance)
                .foregroundStyle(Color.white)
            
            Button(action: {
                withAnimation {
                    isWalletSelectionShowing.toggle()
                }
            }, label: {
                HStack {
                    getCurrencyIcon(selectedWallet.currencyCode)
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.white)
                        .animation(.linear(duration: 0.1), value: isWalletSelectionShowing)
                        .rotationEffect(.degrees(isWalletSelectionShowing ? -180 : 0))
                        .padding(.leading, 5)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedCorner(radius: 8)
                        .foregroundStyle(Color.clSecondary.opacity(0.5))
                }
            })
            .overlay(alignment: .top) {
                drawerContent
                    .padding(.top, 40)
                    .padding(.trailing, 30)
            }
            .fixedSize()
        }
        .zIndex(1)
        
        HStack {
            LocalizedText(key: LocalizedKeys.walletId(selectedWallet.id))
                .font(.subheadline)
            Button {
                UIPasteboard.general.string = selectedWallet.id
                print("copy wallet id \(selectedWallet.id)")
                withAnimation {
                    isCopyWalletIdShowing = true
                }
            } label: {
                Image(.icCopy)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 15, height: 15)
            }
        }
        .overlay {
            if isCopyWalletIdShowing {
                LocalizedText(key: .copyDone)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.clSecondary.opacity(0.5))
                    }
                    .transition(.opacity)
                    .animation(.linear(duration: 0.1), value: isCopyWalletIdShowing)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isCopyWalletIdShowing = false
                            }
                        }
                    }
                    .padding(.top, 50)
            } else {
                EmptyView()
            }
        }
        .background(.clPrimary)
        .foregroundStyle(.white)
        .zIndex(0)
    }
    
    @ViewBuilder
    private var drawerContent: some View {
        if isWalletSelectionShowing {
            VStack {
                let wallets = virtualWallets.filter { $0.id != selectedWallet.id }
                ForEach(wallets, id: \.id) { wallet in
                    getCurrencyIcon(wallet.currencyCode)
                        .onTapGesture {
                            withAnimation {
                                selectWalletAction(wallet.currencyCode)
                                isWalletSelectionShowing = false
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func getCurrencyIcon(_ code: String) -> some View {
        if let currencyType = CurrencyType(rawValue: code) {
            let model = CurrencyPropertyFactory().create(with: currencyType)
            model.flagIcon
                .resizable()
                .frame(width: 25, height: 25)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    WalletView(virtualWallets:[], selectedWallet: VirtualWallet(id: "123123123", currencyCode: "TRY", balance: 12312), selectWalletAction: { _ in })
}
