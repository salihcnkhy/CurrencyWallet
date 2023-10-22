//
//  BuyCurrencyUseCase.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import Foundation

public enum BuyCurrencyUseCaseError: Error {
    case walletNotFound
    case walletBalanceNotEnough
    case unknown
}

public protocol BuyCurrencyUseCaseProtocol {
    func execute(curencyAmount: Double, liraAmount: Double, for walletId: String, completion: @escaping (Result<Void, BuyCurrencyUseCaseError>) -> Void)
}

struct MockBuyCurrencyUseCase: BuyCurrencyUseCaseProtocol {
    func execute(curencyAmount: Double, liraAmount: Double, for walletId: String, completion: @escaping (Result<Void, BuyCurrencyUseCaseError>) -> Void) {
        
    }
}
 
public struct BuyCurrencyUseCase: BuyCurrencyUseCaseProtocol {
    private let repository: WalletRepository
    
    public init(repository: WalletRepository) {
        self.repository = repository
    }
    
    public func execute(curencyAmount: Double, liraAmount: Double, for currencyCode: String, completion: @escaping (Result<Void, BuyCurrencyUseCaseError>) -> Void) {
        if curencyAmount == 0 || liraAmount == 0 {
            return
        }
        
        if currencyCode.isEmpty {
            return
        }
        
        // TODO: TRY Wallet'ını çekip gerekli lira walletta var mı bakılması gerekiyor.
        
        
        // TODO: belki adapterda wallet'ın güncellediğini söylemek yerine bussinessal bir iş olduğu için burada söylemek de mantıklı olabilir.
        repository.buyCurrency(currencyAmount: curencyAmount, liraAmount: liraAmount, wallet: currencyCode, completion: { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            
            switch error {
                case .walletNotFound:
                    completion(.failure(.walletNotFound))
                case .walletBalanceNotEnough:
                    completion(.failure(.walletBalanceNotEnough))
                default:
                    completion(.failure(.unknown))
            }
        })
    }
}
