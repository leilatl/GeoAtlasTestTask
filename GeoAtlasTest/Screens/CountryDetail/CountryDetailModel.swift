//
//  CountryModel.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//
 
import Foundation

/// модель, описывающая данные для работы экрана Country Detail
enum CountryDetailModel {
	/// модель, описывающая данные API
	struct NetworkingData {
		struct CountryDetailData: Decodable {
			let flags: FlagImg
			let name: Name
			let subregion: String
			let capital: [String]?
			let capitalInfo: CapitalInfo?
			let population: Int
			let area: Float
			let currencies: [String:CurrencyValue]?
			let timezones: [String]
		}
		
		struct CapitalInfo: Decodable {
			let latlng: [Float]?
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
		let image: String
		let name: String
		let capital: [String]?
		let coordinates: [Float]
		let population: Int
		let area: Float
		let currencies: [String]
		let timezones: [String]
		let region: String
	}
	/// модель, описывающая данные для отображения на экране
	struct ViewModel {
		let flag: String
		let name: String
		let capital: String
		let coordinates: String
		let population: String
		let area: String
		let currencies: String
		let timezones: String
		let region: String
	}
}
