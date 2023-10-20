//
//  String+UniqueInt.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation

extension String { // TODO: Localde cüzdan oluştururken id'leri unique yapmak için kullanıldı.
    private static var counter = 3245324
    static func getUniqueInt() -> String {
        Self.counter += 1
        return "\(Self.counter)"
    }
}
