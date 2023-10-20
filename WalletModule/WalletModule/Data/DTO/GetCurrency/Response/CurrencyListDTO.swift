//
//  CurrencyListDTO.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public struct CurrencyListDTO: Decodable {
    public let data: [CurrencyItemDTO]
    public let updatedAt: Date
    
    public init(data: [CurrencyItemDTO], updatedAt: Date) {
        self.data = data
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataResponse = try container.decode(DataResponse.self, forKey: .data)
        self.data = [
            dataResponse.usd,
            dataResponse.eur,
            dataResponse.gbp,
            dataResponse.cny,
            dataResponse.rub
        ]
        self.updatedAt = Date() // TODO: is api response has updatedAt property?
    }
    
    struct DataResponse: Decodable {
        let usd: CurrencyItemDTO
        let eur: CurrencyItemDTO
        let gbp: CurrencyItemDTO
        let cny: CurrencyItemDTO
        let rub: CurrencyItemDTO

        enum CodingKeys: String, CodingKey {
            case usd = "USD"
            case eur = "EUR"
            case gbp = "GBP"
            case cny = "CNY"
            case rub = "RUB"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CurrencyListDTO.DataResponse.CodingKeys> = try decoder.container(keyedBy: CurrencyListDTO.DataResponse.CodingKeys.self)
            self.usd = try container.decode(CurrencyItemDTO.self, forKey: CurrencyListDTO.DataResponse.CodingKeys.usd)
            self.eur = try container.decode(CurrencyItemDTO.self, forKey: CurrencyListDTO.DataResponse.CodingKeys.eur)
            self.gbp = try container.decode(CurrencyItemDTO.self, forKey: CurrencyListDTO.DataResponse.CodingKeys.gbp)
            self.cny = try container.decode(CurrencyItemDTO.self, forKey: CurrencyListDTO.DataResponse.CodingKeys.cny)
            self.rub = try container.decode(CurrencyItemDTO.self, forKey: CurrencyListDTO.DataResponse.CodingKeys.rub)
        }
    }
}
