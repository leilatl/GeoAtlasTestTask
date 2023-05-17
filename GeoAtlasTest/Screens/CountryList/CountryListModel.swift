//
//  CountryListModel.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import Foundation
import UIKit

/// модель, описывающая данные для работы экрана Country List
enum CountryListModel {
	/// модель, описывающая данные API
	struct NetworkingData {
		struct CountryListData: Decodable {
			
			struct Country: Decodable {
				let name: Name
				let capital: [String]?
				let population: Int
				let flags: FlagImg
				let currencies: [String: CurrencyValue]?
				let continents: [String]
				let area: Float
				let cca2: String
			}
		}
		
		struct FlagImg: Decodable {
			let png: String
		}
		struct Name: Decodable {
			let common: String
		}
		struct CurrencyValue: Decodable {
			public let name: String
			public let symbol: String?
		}
	}
	
	/// модель, описывающая данные для работы внутренней логики
	struct Data {
		var continents: [String: [Country]]
		
		struct Country {
			let image: String
			let name: String
			let capital: [String]?
			let population: Int
			let area: Float
			let currencies: [String: CountryListModel.NetworkingData.CurrencyValue]?
			let cca2: String
		}
	}
	/// модель, описывающая данные для отображения на экране
	struct ViewModel {
		var continents: [ContinentViewModel]
		
		struct ContinentViewModel {
			let name: String
			var countries: [CountryViewModel]
		}
		
		struct CountryViewModel {
			let flag: String
			let name: String
			let capital: String
			let population: NSMutableAttributedString
			let area: NSMutableAttributedString
			let currencies: String
			let cca2: String
		}
	}
}
