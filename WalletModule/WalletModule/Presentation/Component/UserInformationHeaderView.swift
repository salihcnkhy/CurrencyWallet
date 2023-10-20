//
//  UserInformationHeaderView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

struct UserInformationHeaderView: View {
    var fullName: String
    var wallets: [VirtualWallet]
    var hasError: Bool
    @Binding var selectedWallet: VirtualWallet?
    var selectWalletAction: (String) -> Void

    var body: some View {
        VStack {
            if hasError { // TODO: Error View koyulacak. Tekrar dene butonu olacak.
                EmptyView()
                    .frame(height: 70)
            } else {
                HStack(spacing: .zero) {
                    LocalizedText(key: .greeting(fullName))
                        .font(.title3)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                if let selectedWallet {
                    WalletView(virtualWallets: wallets, selectedWallet: selectedWallet, selectWalletAction: selectWalletAction)
                } else {
                    EmptyView()
                        .frame(height: 70)
                }
            }
        }
        .padding()
        .background {
            Color.clPrimary
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea()
        }
    }
}

#Preview {
    UserInformationHeaderView(fullName: "Salihcan Kahya",
                              wallets: [
                                VirtualWallet(id: "234234", currencyCode: "TRY", balance: 5000),
                                VirtualWallet(id: "234232", currencyCode: "EUR", balance: 150),
                                VirtualWallet(id: "234233", currencyCode: "USD", balance: 120),
                              ], hasError: false, selectedWallet: .constant(nil), selectWalletAction: {_ in})
}


extension String {
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: NSLocalizedString(self, comment: ""), locale: nil, arguments: arguments)
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
