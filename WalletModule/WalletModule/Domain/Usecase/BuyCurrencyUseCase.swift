//
//  BuyCurrencyUseCase.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import Foundation

public protocol BuyCurrencyUseCaseProtocol {
    func execute(curencyAmount: Double, liraAmount: Double, for walletId: String, completion: @escaping () -> Void)
}

struct MockBuyCurrencyUseCase: BuyCurrencyUseCaseProtocol {
    func execute(curencyAmount: Double, liraAmount: Double, for walletId: String, completion: @escaping () -> Void) {
        
    }
}
 
public struct BuyCurrencyUseCase: BuyCurrencyUseCaseProtocol {
    private let repository: WalletRepository
    
    public init(repository: WalletRepository) {
        self.repository = repository
    }
    
    public func execute(curencyAmount: Double, liraAmount: Double, for currencyCode: String, completion: @escaping () -> Void) {
        if curencyAmount == 0 || liraAmount == 0 {
            return
        }
        
        if currencyCode.isEmpty {
            return
        }
        
        // TODO: TRY Wallet'ını çekip gerekli lira walletta var mı bakılması gerekiyor.
        
        
        // TODO: belki adapterda wallet'ın güncellediğini söylemek yerine bussinessal bir iş olduğu için burada söylemek de mantıklı olabilir.
        repository.buyCurrency(currencyAmount: curencyAmount, liraAmount: liraAmount, wallet: currencyCode, completion: completion)
    }
}
